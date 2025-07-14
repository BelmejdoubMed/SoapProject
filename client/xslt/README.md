# XSLT Currency Conversion Interface

This directory contains a complete **XSLT (Extensible Stylesheet Language Transformations)** implementation for the Currency Conversion Web Service interface. XSLT provides a powerful way to transform XML data into HTML, demonstrating server-side templating and data binding capabilities.

---

## 🎯 **What is XSLT?**

**XSLT** is a language for transforming XML documents into other formats (HTML, XML, text). In this implementation:

- **XML Data** (`sample-data.xml`) contains service information, operations, and configuration
- **XSLT Stylesheet** (`enhanced-client.xsl`) transforms the XML into a complete HTML interface
- **Browser Processing** (`transform.html`) performs the transformation and displays the result

---

## 📁 **File Structure**

```
client/xslt/
├── currency-client.xsl          # Basic XSLT stylesheet
├── enhanced-client.xsl          # Advanced data-driven XSLT
├── sample-data.xml              # XML data source
├── transform.html               # Browser-based transformation
└── README.md                    # This documentation
```

---

## 🚀 **Quick Start**

### **Method 1: Browser Transformation (Recommended)**
```bash
# Start a local web server
cd client/xslt
python3 -m http.server 8000

# Open in browser
http://localhost:8000/transform.html
```

### **Method 2: Direct XSLT Viewing**
```bash
# View the generated stylesheet
open currency-client.xsl

# View the data-driven stylesheet  
open enhanced-client.xsl

# View the XML data
open sample-data.xml
```

---

## 🔧 **How XSLT Transformation Works**

### **1. XML Data Source**
`sample-data.xml` contains structured information about the service:

```xml
<currencyService>
    <serviceInfo>
        <name>Currency Conversion Web Service</name>
        <endpoint>http://localhost:8080/...</endpoint>
        <!-- ... more service data ... -->
    </serviceInfo>
    <operations>
        <operation>
            <name>convertCurrency</name>
            <description>Convert currency amounts</description>
            <!-- ... operation details ... -->
        </operation>
    </operations>
    <supportedCurrencies>
        <!-- ... currency data ... -->
    </supportedCurrencies>
</currencyService>
```

### **2. XSLT Stylesheet**
`enhanced-client.xsl` transforms the XML into HTML:

```xsl
<!-- Dynamic title from XML data -->
<title><xsl:value-of select="currencyService/serviceInfo/name"/></title>

<!-- Generate currency options from XML -->
<xsl:for-each select="currencyService/supportedCurrencies/currency">
    <option value="{code}">
        <xsl:value-of select="code"/> - <xsl:value-of select="name"/>
    </option>
</xsl:for-each>

<!-- Dynamic operation cards -->
<xsl:for-each select="currencyService/operations/operation">
    <div class="operation-card">
        <span class="operation-name"><xsl:value-of select="name"/></span>
        <!-- ... more dynamic content ... -->
    </div>
</xsl:for-each>
```

### **3. JavaScript Processing**
`transform.html` loads XML and XSLT, then transforms them:

```javascript
// Load XML and XSLT files
const [xmlDoc, xslDoc] = await Promise.all([
    loadXMLDocument('sample-data.xml'),
    loadXMLDocument('enhanced-client.xsl')
]);

// Create and perform transformation
const xsltProcessor = new XSLTProcessor();
xsltProcessor.importStylesheet(xslDoc);
const result = xsltProcessor.transformToFragment(xmlDoc, document);

// Display transformed HTML
document.body.appendChild(result);
```

---

## 🌟 **Key Features**

### **Data-Driven Content**
- ✨ **Dynamic Titles** - Generated from XML service information
- 🔄 **Auto-Generated Operations** - Service operations created from XML data
- 💰 **Currency Lists** - Dropdown options populated from XML
- 📊 **Live Configuration** - Settings pulled from XML configuration

### **XSLT Capabilities Demonstrated**
- 🎨 **Template Matching** - XPath selectors for data extraction
- 🔀 **Conditional Logic** - `xsl:if` for conditional rendering
- 🔁 **Loops** - `xsl:for-each` for repeating elements
- 📊 **Data Binding** - `xsl:value-of` for dynamic content
- 🧮 **Functions** - `count()` for data calculations

### **Advanced Features**
- 📱 **Responsive Design** - Modern CSS with mobile support
- ⚡ **Interactive Elements** - JavaScript for SOAP service calls
- 🎯 **Data Validation** - XPath expressions for data selection
- 🔗 **Dynamic URLs** - Attribute value templates `{xpath}`

---

## 🛠️ **Customization Guide**

### **Modifying XML Data**
Edit `sample-data.xml` to change:

```xml
<!-- Add new currency -->
<currency>
    <code>AUD</code>
    <name>Australian Dollar</name>
    <symbol>A$</symbol>
    <country>Australia</country>
</currency>

<!-- Add new service operation -->
<operation>
    <name>getExchangeRate</name>
    <description>Get current exchange rate</description>
    <returnType>double</returnType>
</operation>
```

### **Customizing XSLT Templates**
Edit `enhanced-client.xsl` to modify output:

```xsl
<!-- Custom currency card styling -->
<xsl:template match="currency">
    <div class="currency-card-custom">
        <h3><xsl:value-of select="name"/></h3>
        <span class="symbol"><xsl:value-of select="symbol"/></span>
        <p><xsl:value-of select="country"/></p>
    </div>
</xsl:template>

<!-- Conditional styling -->
<xsl:if test="returnType='boolean'">
    <span class="boolean-operation">Boolean</span>
</xsl:if>
```

### **Adding New Sections**
Extend the interface with new XML sections:

```xml
<!-- Add to sample-data.xml -->
<apiDocumentation>
    <section>
        <title>Getting Started</title>
        <content>Basic usage examples...</content>
    </section>
</apiDocumentation>
```

```xsl
<!-- Add to enhanced-client.xsl -->
<section class="card">
    <h2>📚 API Documentation</h2>
    <xsl:for-each select="currencyService/apiDocumentation/section">
        <div class="doc-section">
            <h3><xsl:value-of select="title"/></h3>
            <p><xsl:value-of select="content"/></p>
        </div>
    </xsl:for-each>
</section>
```

---

## 🎨 **Styling and Design**

### **CSS Integration**
The XSLT includes embedded CSS for:

- **Modern Design** - Gradient backgrounds, glass morphism effects
- **Responsive Layout** - CSS Grid and Flexbox for all screen sizes  
- **Interactive Elements** - Hover effects and transitions
- **Component Styling** - Cards, buttons, forms, and data displays

### **Dynamic Styling**
XSLT can generate CSS classes based on data:

```xsl
<!-- Conditional CSS classes -->
<div class="operation-card {returnType}-operation">
    <!-- content -->
</div>

<!-- Dynamic styles -->
<style>
    .currency-{code} {
        background-color: <xsl:value-of select="color"/>;
    }
</style>
```

---

## 🔍 **Browser Compatibility**

### **Supported Browsers**
- ✅ **Chrome** - Full XSLT support
- ✅ **Firefox** - Full XSLT support  
- ✅ **Safari** - Full XSLT support
- ✅ **Edge** - Full XSLT support

### **Requirements**
- 🌐 **HTTP Server** - XSLT requires files served via HTTP (not file://)
- 📄 **Content-Type** - Proper XML MIME types for transformation
- 🔒 **CORS** - Cross-origin policies may affect local file loading

---

## 🧪 **Testing the Interface**

### **Functionality Tests**
1. **Data Loading** - Verify XML data loads correctly
2. **Transformation** - Check XSLT processing completes
3. **Display** - Confirm HTML renders properly
4. **Interactivity** - Test JavaScript SOAP calls
5. **Responsive** - Check mobile and desktop layouts

### **XSLT Validation**
```bash
# Validate XML structure
xmllint --noout sample-data.xml

# Test XSLT syntax (if xmlstarlet is installed)
xmlstarlet tr enhanced-client.xsl sample-data.xml
```

### **Browser Console**
Check for transformation messages:
```
✅ Loading XML data and XSLT stylesheet...
✅ XML and XSLT loaded successfully  
✅ Performing XSLT transformation...
✅ XSLT transformation completed successfully
```

---

## 🔧 **Troubleshooting**

### **Common Issues**

#### **CORS Errors**
```
Error: Failed to load sample-data.xml: 0
```
**Solution**: Use HTTP server instead of opening files directly
```bash
python3 -m http.server 8000
```

#### **XSLT Not Supported**
```
Error: Browser does not support XSLT processing
```
**Solution**: Use a modern browser (Chrome, Firefox, Safari, Edge)

#### **File Not Found**
```
Error: Failed to load enhanced-client.xsl: 404
```
**Solution**: Check file paths and ensure proper directory structure

#### **Transformation Errors**
```
Error: Invalid XSLT or XML format
```
**Solution**: Validate XML and XSLT syntax

### **Debug Mode**
Enable detailed logging by adding to XSLT:

```xsl
<!-- Debug output -->
<xsl:message>
    Processing <xsl:value-of select="count(//currency)"/> currencies
</xsl:message>
```

---

## 📚 **Learning Resources**

### **XSLT Concepts Used**
- **XPath Expressions** - Data selection and navigation
- **Template Matching** - Pattern-based processing
- **Built-in Functions** - `count()`, `position()`, string functions
- **Attribute Value Templates** - `{xpath}` syntax
- **Conditional Processing** - `xsl:if`, `xsl:choose`

### **Advanced Techniques**
- **Parameters** - `xsl:param` for configuration
- **Variables** - `xsl:variable` for data storage
- **Includes** - `xsl:include` for modular stylesheets
- **Output Methods** - HTML, XML, text generation

---

## 🎯 **Use Cases**

### **This XSLT Interface Is Perfect For:**
- 📊 **Data Visualization** - Transform XML reports into HTML dashboards
- 🔄 **Configuration Management** - Generate interfaces from XML configs
- 📋 **Documentation** - Create web docs from XML specifications
- 🌐 **API Interfaces** - Build clients from service descriptions
- 🎨 **Template Systems** - Server-side rendering with XML data

### **Real-World Applications:**
- Web service interface generation
- Configuration file visualization  
- API documentation systems
- Data transformation pipelines
- Report generation from XML

---

**🎉 Your XSLT Currency Conversion Interface is ready!**

This implementation demonstrates the power of XSLT for creating dynamic, data-driven web interfaces. The XML data drives the entire interface structure, making it easy to maintain and extend. Perfect for scenarios where you need to generate HTML interfaces from XML data sources.

Visit `transform.html` in your browser to see the XSLT transformation in action! 