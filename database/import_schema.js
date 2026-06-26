// Railway MySQL schema import script
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

async function importSchema() {
  const connection = await mysql.createConnection({
    host: 'zephyr.proxy.rlwy.net',
    port: 51451,
    user: 'root',
    password: 'jMUXUXwmuedDMTAwaCjzruPjSPwmdvui',
    database: 'railway',
    ssl: { rejectUnauthorized: false },
    multipleStatements: true
  });

  console.log('Connected to Railway MySQL!');

  const schema = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');

  try {
    await connection.query(schema);
    console.log('Schema executed successfully!');
  } catch (err) {
    console.error('Schema error:', err.message);
  }

  // Verify tables
  const [rows] = await connection.query('SHOW TABLES');
  console.log('\nTables in railway database:');
  rows.forEach(r => console.log(` - ${Object.values(r)[0]}`));

  // Verify admin
  const [admins] = await connection.query('SELECT id, username, role FROM admins');
  console.log('\nAdmin users:');
  admins.forEach(a => console.log(` - ${a.id}: ${a.username} (${a.role})`));

  await connection.end();
  console.log('\nDone! Schema imported successfully.');
}

importSchema().catch(err => {
  console.error('Import failed:', err.message);
  process.exit(1);
});
