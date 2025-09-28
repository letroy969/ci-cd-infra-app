# Integration Guide: Adding CI/CD Project to Blade Runner Portfolio

## 🎯 Quick Integration Steps

### Step 1: Add the Project Card
1. **Open your portfolio**: `blade_runner_portfolio.html`
2. **Find the projects section**: Look for `<section id="projects" class="projects">`
3. **Find the projects grid**: Look for `<div class="projects-grid">`
4. **Add the new project card**: Insert the project card HTML from `blade-runner-project-card.html` into your existing projects grid

### Step 2: Add the CSS Styles
1. **Find your existing CSS**: Look for the `<style>` section in your portfolio
2. **Add the CI/CD styles**: Copy all the CSS from the `blade-runner-project-card.html` file (everything inside `<style>` tags)
3. **Paste at the end**: Add the styles before the closing `</style>` tag

### Step 3: Add the JavaScript
1. **Find your existing JavaScript**: Look for the `<script>` section
2. **Add the CI/CD JavaScript**: Copy the JavaScript from `blade-runner-project-card.html`
3. **Add before closing**: Insert before the closing `</script>` tag

### Step 4: Add the Modal HTML
1. **Find a good place**: Look for other modals or before the closing `</body>` tag
2. **Add the modal**: Copy the modal HTML from `blade-runner-project-card.html`
3. **Insert the modal**: Add it after your existing content

## 📍 Exact Integration Points

### Where to Add Project Card:
```html
<!-- In your projects-grid section, add after your existing project cards -->
<div class="projects-grid">
    <!-- Your existing project cards here -->
    
    <!-- ADD THIS NEW PROJECT CARD HERE -->
    <div class="project-card purple">
        <!-- ... project card content ... -->
    </div>
</div>
```

### Where to Add Modal:
```html
<!-- Add before closing </body> tag -->
</section>

<!-- ADD THE CI/CD MODAL HERE -->
<div id="ci-cd-modal" class="project-modal">
    <!-- ... modal content ... -->
</div>

</body>
```

## 🔗 Live Demo URL Setup

### Option 1: Automatic (Recommended)
1. **Deploy your infrastructure** using the GitHub Actions pipeline
2. **Run the get-demo-url script**:
   ```bash
   cd ci-cd-infra-app
   bash get-demo-url.sh
   ```
3. **Copy the ALB DNS name** from the output
4. **Update the JavaScript** in your portfolio:
   ```javascript
   const deployedUrl = 'http://YOUR_ACTUAL_ALB_DNS_NAME';
   ```

### Option 2: Manual
1. **Go to your GitHub repository**: https://github.com/letroy969/ci-cd-infra-app
2. **Check the Actions tab** for successful deployment
3. **Go to AWS Console** → ECS → Load Balancers
4. **Find your ALB** and copy the DNS name
5. **Update the portfolio** with the real URL

## 🎨 Customization Options

### Change Project Color Theme:
```css
/* Change from purple to another color */
.project-card.purple {
    background: linear-gradient(135deg, rgba(YOUR_COLOR, 0.1) 0%, rgba(YOUR_COLOR, 0.05) 100%);
    border: 1px solid rgba(YOUR_COLOR, 0.3);
}
```

### Update Project Status:
```html
<!-- Change status text -->
<div class="project-status">
    <div class="project-status-dot"></div>
    <span class="project-status-text">LIVE</span> <!-- Change to: ACTIVE, DEPLOYED, etc. -->
</div>
```

### Modify Tech Stack:
```html
<!-- Add or remove tech tags -->
<div class="project-tech-stack">
    <span class="project-tech-tag">Terraform</span>
    <span class="project-tech-tag">AWS</span>
    <!-- Add more tags as needed -->
</div>
```

## 🚀 Final Result

After integration, you'll have:
- ✅ **New project card** in your projects section with purple theme
- ✅ **Clickable project** that opens detailed modal
- ✅ **Live Demo button** (once infrastructure is deployed)
- ✅ **Code button** linking to GitHub repository
- ✅ **Detailed modal** with architecture, specs, and metrics
- ✅ **Responsive design** that matches your Blade Runner theme

## 🔧 Troubleshooting

### Project Card Not Showing:
- Check that you added the HTML in the correct location
- Verify the CSS is included
- Make sure there are no syntax errors

### Modal Not Opening:
- Ensure the JavaScript is included
- Check browser console for errors
- Verify the modal HTML is added

### Live Demo Button Not Working:
- Update the `deployedUrl` variable with your actual ALB DNS
- Make sure your infrastructure is deployed successfully
- Check that the ALB is accessible from the internet

### Styling Issues:
- Verify all CSS is copied correctly
- Check for conflicts with existing styles
- Ensure responsive breakpoints work on mobile

## 📱 Testing

1. **Desktop**: Test the project card hover effects and modal functionality
2. **Mobile**: Verify responsive design and touch interactions
3. **Links**: Test both Live Demo and Code buttons
4. **Performance**: Ensure the additional content doesn't slow down your portfolio

---

**Need help?** Check the browser console for any JavaScript errors or styling conflicts!
