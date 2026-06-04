// Meme Collection browser extension
// Adds right-click "Save to Meme Collection" on images

const HOST_NAME = "me.memes.collection";

// Create context menu on install
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "save-to-meme-collection",
    title: "Save to Meme Collection",
    contexts: ["image"],
  });
});

// Handle context menu clicks
chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  if (info.menuItemId !== "save-to-meme-collection" || !info.srcUrl) {
    return;
  }

  try {
    // Fetch the image with credentials (works for most sites)
    const response = await fetch(info.srcUrl, {
      credentials: "include",
      cache: "force-cache",
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    const blob = await response.blob();
    const mimeType = blob.type || "image/png";
    const buffer = await blob.arrayBuffer();

    // Convert to base64
    const bytes = new Uint8Array(buffer);
    let binary = "";
    for (let i = 0; i < bytes.length; i++) {
      binary += String.fromCharCode(bytes[i]);
    }
    const data = btoa(binary);

    // Send to native host
    const host = chrome.runtime.connectNative(HOST_NAME);

    host.onMessage.addListener((response) => {
      if (response.success) {
        chrome.notifications.create({
          type: "basic",
          iconUrl: "icons/icon48.png",
          title: "Meme Collection",
          message: `Saved: ${response.filename}`,
        });
      } else {
        chrome.notifications.create({
          type: "basic",
          iconUrl: "icons/icon48.png",
          title: "Meme Collection — Error",
          message: response.error || "Failed to save image",
        });
      }
      host.disconnect();
    });

    host.onDisconnect.addListener(() => {
      if (chrome.runtime.lastError) {
        chrome.notifications.create({
          type: "basic",
          iconUrl: "icons/icon48.png",
          title: "Meme Collection — Error",
          message: `Native host not found. Run setup script?`,
        });
      }
    });

    host.postMessage({
      action: "save",
      mimeType: mimeType,
      data: data,
    });
  } catch (err) {
    chrome.notifications.create({
      type: "basic",
      iconUrl: "icons/icon48.png",
      title: "Meme Collection — Error",
      message: err.message,
    });
  }
});
