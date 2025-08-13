// lib/views/widgets/dialogs/confirmation_dialog.dart
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? cancelColor;
  final IconData? icon;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.cancelColor,
    this.icon,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultConfirmColor = isDangerous 
        ? Colors.red 
        : (confirmColor ?? theme.primaryColor);
    final defaultCancelColor = cancelColor ?? Colors.grey[600];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: defaultConfirmColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: defaultConfirmColor,
                ),
              ),
            
            if (icon != null) const SizedBox(height: 16),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: defaultCancelColor,
                      side: BorderSide(color: defaultCancelColor!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      cancelText ?? 'Cancel',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultConfirmColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      confirmText ?? 'Confirm',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Static method to show the dialog
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    Color? cancelColor,
    IconData? icon,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        icon: icon,
        isDangerous: isDangerous,
      ),
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String itemName;
  final String? customMessage;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.itemName,
    this.customMessage,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final message = customMessage ?? 
        'Are you sure you want to delete "$itemName"? This action cannot be undone.';

    return ConfirmationDialog(
      title: title,
      message: message,
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.delete_outline,
      isDangerous: true,
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String itemName,
    String? customMessage,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => DeleteConfirmationDialog(
        title: title,
        itemName: itemName,
        customMessage: customMessage,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const LogoutConfirmationDialog({
    super.key,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Stay',
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.logout,
      confirmColor: Colors.orange,
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LogoutConfirmationDialog(
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}

class SaveChangesDialog extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onDiscard;
  final VoidCallback? onCancel;

  const SaveChangesDialog({
    super.key,
    this.onSave,
    this.onDiscard,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_outlined,
                size: 32,
                color: Colors.orange,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Save Changes?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'You have unsaved changes. What would you like to do?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            Column(
              children: [
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop('save');
                      onSave?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Discard Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop('discard');
                      onDiscard?.call();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Discard Changes',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop('cancel');
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<String?> show(
    BuildContext context, {
    VoidCallback? onSave,
    VoidCallback? onDiscard,
    VoidCallback? onCancel,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SaveChangesDialog(
        onSave: onSave,
        onDiscard: onDiscard,
        onCancel: onCancel,
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultIconColor = iconColor ?? theme.primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: defaultIconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: defaultIconColor,
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  buttonText ?? 'OK',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
  }