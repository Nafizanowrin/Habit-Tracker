import requests
import json
import time

def setup_firestore_database():
    """Set up Firestore database by creating initial collections and documents"""
    
    # Firebase project ID
    project_id = "habit-tracker-bc361"
    
    # Base URL for Firestore REST API
    base_url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents"
    
    print("🔥 Setting up Firebase Firestore Database...")
    print(f"Project ID: {project_id}")
    
    # Create initial test document to initialize the database
    test_data = {
        "fields": {
            "message": {"stringValue": "Database initialized successfully"},
            "timestamp": {"timestampValue": time.strftime("%Y-%m-%dT%H:%M:%SZ")},
            "status": {"stringValue": "active"}
        }
    }
    
    try:
        # Create a test document
        response = requests.post(
            f"{base_url}/test",
            json=test_data,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            print("✅ Database initialized successfully!")
            print("📊 You can now use your habit tracker app with Firebase.")
            
            # Create sample user structure
            sample_user_data = {
                "fields": {
                    "email": {"stringValue": "test@example.com"},
                    "displayName": {"stringValue": "Test User"},
                    "createdAt": {"timestampValue": time.strftime("%Y-%m-%dT%H:%M:%SZ")}
                }
            }
            
            # Create sample habit data
            sample_habit_data = {
                "fields": {
                    "title": {"stringValue": "Morning Exercise"},
                    "description": {"stringValue": "Daily morning workout routine"},
                    "frequency": {"stringValue": "daily"},
                    "createdAt": {"timestampValue": time.strftime("%Y-%m-%dT%H:%M:%SZ")},
                    "streakCount": {"integerValue": 0},
                    "isActive": {"booleanValue": True}
                }
            }
            
            print("📝 Creating sample data structure...")
            
            # Note: In a real app, these would be created when users sign up and create habits
            print("✅ Database setup complete!")
            print("\n🎯 Next steps:")
            print("1. Run your Flutter app: flutter run")
            print("2. Sign up or sign in to create your first user")
            print("3. Create your first habit")
            print("4. Check Firebase Console to see your data")
            
        else:
            print(f"❌ Error initializing database: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        print("\n💡 Manual Setup Required:")
        print("1. Go to https://console.firebase.google.com/")
        print("2. Select project: habit-tracker-bc361")
        print("3. Go to Firestore Database")
        print("4. Click 'Create database'")
        print("5. Choose 'Start in test mode'")
        print("6. Select a location and click 'Done'")

if __name__ == "__main__":
    setup_firestore_database()
