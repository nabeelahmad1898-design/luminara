# Supabase Connectivity Troubleshooting Guide

## Error: "Failed to fetch (api.supabase.com)"

This error indicates network connectivity issues with Supabase. Here are the steps to troubleshoot:

### 1. **Check Internet Connection**
- Ensure you have a stable internet connection
- Try accessing other websites to confirm connectivity
- Check if your firewall is blocking the connection

### 2. **Verify Supabase Project Status**
- Go to [Supabase Status Page](https://status.supabase.com/)
- Check if there are any ongoing outages
- Verify your project is not paused or suspended

### 3. **Check Supabase Configuration**
- Open `supabase-config.html` in your browser
- Verify your Supabase URL and API key are correct
- Make sure you're using the correct project credentials

### 4. **Test Supabase Connection**
- Open `dashboard.html`
- Click **"Debug Auth"** button
- Check the console for detailed error messages
- Use **"Check Schema"** button to test database access

### 5. **Common Solutions**

#### **Solution A: Clear Browser Cache**
```bash
# Clear browser cache and cookies
# Or use Ctrl+Shift+Delete in your browser
```

#### **Solution B: Check CORS Settings**
- Go to your Supabase Dashboard
- Navigate to Settings > API
- Ensure your domain is in the allowed origins list
- Add `localhost` and your domain to CORS settings

#### **Solution C: Verify API Keys**
- Check if you're using the correct API key (anon key, not service role)
- Ensure the API key hasn't been rotated
- Verify the project URL is correct

#### **Solution D: Network/Firewall Issues**
- Check if your network blocks Supabase domains
- Try using a different network (mobile hotspot)
- Disable VPN if you're using one
- Check corporate firewall settings

### 6. **Alternative Testing Methods**

#### **Test with curl (Command Line)**
```bash
# Replace with your actual Supabase URL and key
curl -X GET "https://your-project.supabase.co/rest/v1/products?select=*" \
  -H "apikey: your-anon-key" \
  -H "Authorization: Bearer your-anon-key"
```

#### **Test with Postman or Insomnia**
- Create a new request to your Supabase REST API
- Use the same headers as above
- Test if the connection works outside the browser

### 7. **Emergency Workaround**
If Supabase is completely unavailable:
- The website will fall back to local storage
- Orders and products will be stored locally
- Data will persist in your browser
- Sync will resume when connection is restored

### 8. **Contact Support**
If none of the above solutions work:
- Check Supabase Discord for community help
- Contact Supabase support with your project details
- Include error logs and network information

## Quick Diagnostic Steps

1. **Open browser console** (F12)
2. **Go to Network tab**
3. **Try to use the dashboard**
4. **Look for failed requests to api.supabase.com**
5. **Check the specific error message**
6. **Note the HTTP status code**

## Common HTTP Status Codes

- **401**: Authentication error - check API keys
- **403**: Permission error - check RLS policies
- **404**: Resource not found - check table names
- **500**: Server error - contact Supabase support
- **Network Error**: Connectivity issue - check network/firewall
