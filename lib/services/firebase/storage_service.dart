// lib/services/firebase/storage_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Upload profile image
  static Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      final fileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('profiles').child(fileName);
      
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Upload profile image from bytes (for web)
  static Future<String> uploadProfileImageFromBytes(
    String userId, 
    Uint8List imageBytes, 
    String fileName
  ) async {
    try {
      final fileExtension = path.extension(fileName).toLowerCase();
      final storageFileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final ref = _storage.ref().child('profiles').child(storageFileName);
      
      final metadata = SettableMetadata(
        contentType: _getContentType(fileExtension),
      );
      
      final uploadTask = ref.putData(imageBytes, metadata);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Upload skill certificate or document
  static Future<String> uploadSkillDocument(
    String userId, 
    String skillId, 
    File documentFile
  ) async {
    try {
      final fileName = path.basename(documentFile.path);
      final fileExtension = path.extension(fileName);
      final storageFileName = 'skill_${skillId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      
      final ref = _storage.ref()
          .child('documents')
          .child(userId)
          .child(storageFileName);
      
      final uploadTask = ref.putFile(documentFile);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload skill document: $e');
    }
  }

  // Upload skill document from bytes (for web)
  static Future<String> uploadSkillDocumentFromBytes(
    String userId,
    String skillId,
    Uint8List documentBytes,
    String fileName
  ) async {
    try {
      final fileExtension = path.extension(fileName).toLowerCase();
      final storageFileName = 'skill_${skillId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      
      final ref = _storage.ref()
          .child('documents')
          .child(userId)
          .child(storageFileName);
      
      final metadata = SettableMetadata(
        contentType: _getContentType(fileExtension),
      );
      
      final uploadTask = ref.putData(documentBytes, metadata);
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();
      
      return downloadURL;
    } catch (e) {
      throw Exception('Failed to upload skill document: $e');
    }
  }

  // Delete file by URL
  static Future<void> deleteFile(String downloadURL) async {
    try {
      final ref = _storage.refFromURL(downloadURL);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  // Delete profile image
  static Future<void> deleteProfileImage(String downloadURL) async {
    try {
      await deleteFile(downloadURL);
    } catch (e) {
      throw Exception('Failed to delete profile image: $e');
    }
  }

  // Delete skill document
  static Future<void> deleteSkillDocument(String downloadURL) async {
    try {
      await deleteFile(downloadURL);
    } catch (e) {
      throw Exception('Failed to delete skill document: $e');
    }
  }

  // Delete all user files
  static Future<void> deleteAllUserFiles(String userId) async {
    try {
      // Delete profile images
      final profilesRef = _storage.ref().child('profiles');
      final profileList = await profilesRef.listAll();
      
      for (final item in profileList.items) {
        if (item.name.contains('profile_$userId')) {
          await item.delete();
        }
      }
      
      // Delete documents
      final documentsRef = _storage.ref().child('documents').child(userId);
      final documentsList = await documentsRef.listAll();
      
      for (final item in documentsList.items) {
        await item.delete();
      }
      
      // Try to delete the user's documents folder if empty
      try {
        await documentsRef.delete();
      } catch (e) {
        // Folder might not be empty or might not exist, ignore error
      }
    } catch (e) {
      throw Exception('Failed to delete user files: $e');
    }
  }

  // Get file metadata
  static Future<FullMetadata> getFileMetadata(String downloadURL) async {
    try {
      final ref = _storage.refFromURL(downloadURL);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  // Check if file exists
  static Future<bool> fileExists(String downloadURL) async {
    try {
      final ref = _storage.refFromURL(downloadURL);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get file size in bytes
  static Future<int> getFileSize(String downloadURL) async {
    try {
      final metadata = await getFileMetadata(downloadURL);
      return metadata.size ?? 0;
    } catch (e) {
      throw Exception('Failed to get file size: $e');
    }
  }

  // Validate file size (in MB)
  static bool isFileSizeValid(int fileSizeInBytes, {int maxSizeMB = 10}) {
    final maxSizeInBytes = maxSizeMB * 1024 * 1024;
    return fileSizeInBytes <= maxSizeInBytes;
  }

  // Validate file type for images
  static bool isValidImageType(String fileName) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final extension = path.extension(fileName).toLowerCase();
    return validExtensions.contains(extension);
  }

  // Validate file type for documents
  static bool isValidDocumentType(String fileName) {
    final validExtensions = ['.pdf', '.doc', '.docx', '.txt', '.jpg', '.jpeg', '.png'];
    final extension = path.extension(fileName).toLowerCase();
    return validExtensions.contains(extension);
  }

  // Get content type based on file extension
  static String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  // Generate thumbnail URL for images (if using Firebase Extensions)
  static String generateThumbnailURL(String originalURL, {int width = 200, int height = 200}) {
    // This assumes you have the "Resize Images" Firebase Extension installed
    // If not, this will just return the original URL
    try {
      final uri = Uri.parse(originalURL);
      final pathSegments = uri.pathSegments.toList();
      
      if (pathSegments.isNotEmpty) {
        final fileName = pathSegments.last;
        final nameWithoutExtension = path.withoutExtension(fileName);
        final extension = path.extension(fileName);
        
        // Insert thumbnail size into filename
        pathSegments[pathSegments.length - 1] = '${nameWithoutExtension}_${width}x$height$extension';
        
        final thumbnailUri = uri.replace(pathSegments: pathSegments);
        return thumbnailUri.toString();
      }
    } catch (e) {
      // If thumbnail generation fails, return original URL
    }
    
    return originalURL;
  }

  // Get storage usage statistics
  static Future<Map<String, dynamic>> getStorageStats(String userId) async {
    try {
      int totalFiles = 0;
      int totalSize = 0;
      List<String> fileTypes = [];

      // Check profile images
      final profilesRef = _storage.ref().child('profiles');
      final profileList = await profilesRef.listAll();
      
      for (final item in profileList.items) {
        if (item.name.contains('profile_$userId')) {
          totalFiles++;
          final metadata = await item.getMetadata();
          totalSize += metadata.size ?? 0;
          final extension = path.extension(item.name).toLowerCase();
          if (!fileTypes.contains(extension)) {
            fileTypes.add(extension);
          }
        }
      }
      
      // Check documents
      final documentsRef = _storage.ref().child('documents').child(userId);
      try {
        final documentsList = await documentsRef.listAll();
        
        for (final item in documentsList.items) {
          totalFiles++;
          final metadata = await item.getMetadata();
          totalSize += metadata.size ?? 0;
          final extension = path.extension(item.name).toLowerCase();
          if (!fileTypes.contains(extension)) {
            fileTypes.add(extension);
          }
        }
      } catch (e) {
        // User documents folder might not exist
      }

      return {
        'totalFiles': totalFiles,
        'totalSizeBytes': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
        'fileTypes': fileTypes,
      };
    } catch (e) {
      throw Exception('Failed to get storage statistics: $e');
    }
  }
}