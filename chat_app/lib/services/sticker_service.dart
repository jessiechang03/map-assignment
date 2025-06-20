class StickerService {
  // Predefined sticker categories and paths
  static const Map<String, List<String>> stickerCategories = {
    'Emotions': [
      '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣',
      '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰',
      '😘', '😗', '😙', '😚', '😋', '😛', '😝', '😜',
      '🤪', '🤨', '🧐', '🤓', '😎', '🤩', '🥳', '😏',
    ],
    'Animals': [
      '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
      '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔',
      '🐧', '🐦', '🐤', '🐣', '🐥', '🦆', '🦅', '🦉',
      '🦇', '🐺', '🐗', '🐴', '🦄', '🐝', '🐛', '🦋',
    ],
    'Food': [
      '🍎', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🍈',
      '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🍆',
      '🥑', '🥦', '🥬', '🥒', '🌶️', '🌽', '🥕', '🧄',
      '🧅', '🥔', '🍠', '🥐', '🍞', '🥖', '🥨', '🧀',
    ],
    'Activities': [
      '⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉',
      '🥏', '🎱', '🪀', '🏓', '🏸', '🏒', '🏑', '🥍',
      '🏏', '🪃', '🥅', '⛳', '🪁', '🏹', '🎣', '🤿',
      '🥊', '🥋', '🎽', '🛹', '🛷', '⛸️', '🥌', '🎿',
    ],
    'Objects': [
      '⌚', '📱', '📲', '💻', '⌨️', '🖥️', '🖨️', '🖱️',
      '🖲️', '🕹️', '🗜️', '💽', '💾', '💿', '📀', '📼',
      '📷', '📸', '📹', '🎥', '📽️', '🎞️', '📞', '☎️',
      '📟', '📠', '📺', '📻', '🎙️', '🎚️', '🎛️', '🧭',
    ],
  };

  // Get all sticker categories
  static Map<String, List<String>> getAllStickers() {
    return stickerCategories;
  }

  // Get stickers by category
  static List<String> getStickersByCategory(String category) {
    return stickerCategories[category] ?? [];
  }

  // Get all categories
  static List<String> getCategories() {
    return stickerCategories.keys.toList();
  }

  // Search stickers
  static List<String> searchStickers(String query) {
    List<String> results = [];
    stickerCategories.forEach((category, stickers) {
      results.addAll(stickers);
    });
    return results;
  }
}