class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    // Check for at least one letter and one number
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    
    if (!hasLetter || !hasNumber) {
      return 'Password must contain at least one letter and one number';
    }
    
    return null;
  }
  
  // Confirm password validator
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // Username validator
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    // Only allow letters, numbers, and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null;
  }
  
  // Required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }
  
  // Room title validator
  static String? validateRoomTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Room title is required';
    }
    
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    
    if (value.length > 50) {
      return 'Title must be less than 50 characters';
    }
    
    return null;
  }
  
  // Room description validator
  static String? validateRoomDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Room description is required';
    }
    
    if (value.length > 200) {
      return 'Description must be less than 200 characters';
    }
    
    return null;
  }
  
  // Message content validator
  static String? validateMessageContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message cannot be empty';
    }
    
    if (value.length > 500) {
      return 'Message must be less than 500 characters';
    }
    
    return null;
  }
  
  // Bio validator
  static String? validateBio(String? value) {
    if (value == null) {
      return null;  // Bio can be empty
    }
    
    if (value.length > 150) {
      return 'Bio must be less than 150 characters';
    }
    
    return null;
  }
}
