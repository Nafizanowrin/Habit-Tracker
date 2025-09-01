const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = {
  "type": "service_account",
  "project_id": "habit-tracker-bc361",
  "private_key_id": "your-private-key-id",
  "private_key": "your-private-key",
  "client_email": "firebase-adminsdk-xxxxx@habit-tracker-bc361.iam.gserviceaccount.com",
  "client_id": "your-client-id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xxxxx%40habit-tracker-bc361.iam.gserviceaccount.com"
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'habit-tracker-bc361'
});

const db = admin.firestore();

async function setupDatabase() {
  try {
    console.log('Setting up Firestore database...');
    
    // Create a test document to initialize the database
    const testDoc = await db.collection('test').doc('init').set({
      message: 'Database initialized',
      timestamp: admin.firestore.FieldValue.serverTimestamp()
    });
    
    console.log('✅ Database setup completed successfully!');
    console.log('You can now use your habit tracker app with Firebase.');
    
  } catch (error) {
    console.error('❌ Error setting up database:', error);
  }
}

setupDatabase();
