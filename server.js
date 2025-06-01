const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db.js'); // file koneksi MySQL
const path = require('path');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(express.static('public'));

// GET all customers (lengkap dengan postalCode dan salesRepEmployeeNumber)
app.get('/customers', (req, res) => {
  const sql = `
    SELECT customerNumber, customerName, contactLastName, contactFirstName,
           phone, addressLine1, city, country, postalCode, salesRepEmployeeNumber, creditLimit
    FROM customers
  `;
  db.query(sql, (err, results) => {
    if (err) {
      console.error('❌ Error fetching customers:', err);
      return res.status(500).json({ error: 'Failed to fetch customers' });
    }
    res.json(results);
  });
});

// POST: Add customer (dengan postalCode dan salesRepEmployeeNumber)
app.post('/customers', (req, res) => {
  const {
    customerNumber,
    customerName,
    contactLastName = 'Unknown',
    contactFirstName = 'Unknown',
    phone = '000-000-0000',
    addressLine1 = 'Unknown Address',
    city = 'Unknown City',
    country = 'Unknown Country',
    postalCode = '00000',
    salesRepEmployeeNumber = null,
    creditLimit = 1000.00
  } = req.body;

  const sql = `
    INSERT INTO customers
    (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1,
     city, country, postalCode, salesRepEmployeeNumber, creditLimit)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [
    customerNumber,
    customerName,
    contactLastName,
    contactFirstName,
    phone,
    addressLine1,
    city,
    country,
    postalCode,
    salesRepEmployeeNumber,
    creditLimit
  ], (err, result) => {
    if (err) {
      console.error('❌ Error adding customer:', err);
      return res.status(500).json({ error: 'Failed to add customer' });
    }
    console.log(`✅ Customer #${customerNumber} added`);
    res.status(200).json({ message: 'Customer added successfully' });
  });
});

// PUT: Update seluruh data customer (bukan cuma nama)
app.put('/customers/:id', (req, res) => {
  const id = req.params.id;
  const {
    customerName,
    contactLastName,
    contactFirstName,
    phone,
    addressLine1,
    city,
    country,
    postalCode,
    salesRepEmployeeNumber,
    creditLimit
  } = req.body;

  const sql = `
    UPDATE customers
    SET customerName = ?, contactLastName = ?, contactFirstName = ?, phone = ?,
        addressLine1 = ?, city = ?, country = ?, postalCode = ?,
        salesRepEmployeeNumber = ?, creditLimit = ?
    WHERE customerNumber = ?
  `;

  db.query(sql, [
    customerName,
    contactLastName,
    contactFirstName,
    phone,
    addressLine1,
    city,
    country,
    postalCode,
    salesRepEmployeeNumber,
    creditLimit,
    id
  ], (err, result) => {
    if (err) {
      console.error('❌ Error updating customer:', err);
      return res.status(500).json({ error: 'Failed to update customer' });
    }
    console.log(`✅ Customer #${id} updated`);
    res.sendStatus(200);
  });
});

// DELETE: Remove customer
app.delete('/customers/:id', (req, res) => {
  const id = req.params.id;

  db.query('DELETE FROM customers WHERE customerNumber = ?', [id], (err) => {
    if (err) {
      console.error('❌ Error deleting customer:', err);
      return res.status(500).json({ error: 'Failed to delete customer' });
    }
    console.log(`🗑️ Customer #${id} deleted`);
    res.sendStatus(200);
  });
});

// Server start
app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
