#!/bin/bash

# 🚀 KenPire Mesh OS - Quick Share Script
# Generates shareable download links and deployment instructions

echo "🎯 KENPIRE MESH OS - DOWNLOAD DISTRIBUTION GENERATOR"
echo "=================================================="

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BASE_URL="https://github.com/kendomaschk/kenpire-mesh-os/releases/download"
PACKAGES_DIR="/workspaces/kenpire-mesh-os"

echo ""
echo "📦 AVAILABLE PACKAGES:"
echo "====================="

# Latest Educational Package
echo "1. 🏄‍♂️ Educational Edition (LATEST - 35MB)"
echo "   File: kenpire_portable_20251108_180125.tar.gz"
echo "   Use: Educational districts, Austin ISD pilot"
echo "   Value: $50K district license opportunity"
echo ""

# Ultra Portable 
echo "2. ⚡ Ultra Portable Edition (34MB)"
echo "   File: kenpire_ultra_portable_20251030_073934.tar.gz" 
echo "   Use: Enterprise demos, USB distribution"
echo "   Value: $2K-$10K enterprise deployment"
echo ""

# Revenue Packages
echo "3. 💰 Enterprise Command Center (65MB)"
echo "   File: revenue_packages/ai_command_center_v3.2.tar.gz"
echo "   Use: Corporate AI governance platform"
echo "   Value: $10K+ enterprise licensing"
echo ""

# SDK Package
echo "4. 🔧 Smart Card SDK (7MB)"
echo "   File: revenue_packages/smart_card_protocol_sdk.tar.gz"
echo "   Use: Developer integration, partner distribution"
echo "   Value: $299-$699 SDK licensing"
echo ""

read -p "Select package to share (1-4): " CHOICE

case $CHOICE in
    1)
        PACKAGE="kenpire_portable_20251108_180125.tar.gz"
        DESCRIPTION="Educational Edition - Austin ISD Ready"
        USE_CASE="Educational sovereignty deployment with patent protection"
        ;;
    2)
        PACKAGE="kenpire_ultra_portable_20251030_073934.tar.gz"
        DESCRIPTION="Ultra Portable Edition - Universal Deployment" 
        USE_CASE="Enterprise demos and USB distribution"
        ;;
    3)
        PACKAGE="revenue_packages/ai_command_center_v3.2.tar.gz"
        DESCRIPTION="Enterprise Command Center - AI Governance Platform"
        USE_CASE="Corporate AI risk management and LinearB killer"
        ;;
    4)
        PACKAGE="revenue_packages/smart_card_protocol_sdk.tar.gz"
        DESCRIPTION="Smart Card SDK - Developer Integration Kit"
        USE_CASE="AI developer ecosystem and partner integration"
        ;;
    *)
        echo "❌ Invalid selection"
        exit 1
        ;;
esac

echo ""
echo "🔧 GENERATING SHARE PACKAGE FOR: $DESCRIPTION"
echo "============================================="

# Generate share instructions
SHARE_FILE="SHARE_INSTRUCTIONS_${TIMESTAMP}.md"

cat > "$SHARE_FILE" << EOF
# 🚀 KenPire Mesh OS - Download & Deploy
**Package:** $DESCRIPTION  
**Generated:** $(date)  
**Use Case:** $USE_CASE  

---

## 📦 **DOWNLOAD**

### **Package Details:**
- **File:** \`$PACKAGE\`
- **Size:** $(du -sh "$PACKAGES_DIR/$PACKAGE" | cut -f1) 
- **Type:** Patent-protected AI platform deployment
- **Compatibility:** Linux ✅ macOS ✅ Windows (WSL) ✅

### **Download Link:**
\`\`\`
$BASE_URL/v3.6.1/$PACKAGE
\`\`\`

*Alternative: Clone repository and extract from releases*

---

## 🚀 **DEPLOYMENT**

### **Quick Start:**
\`\`\`bash
# Download and extract
wget $BASE_URL/v3.6.1/$PACKAGE
tar -xzf $PACKAGE

# Deploy (varies by package)
cd kenpire_portable/     # For educational/portable editions
./start-kenpire.sh       # Starts complete AI mesh

# Access dashboard
open http://localhost:5173
\`\`\`

### **System Requirements:**
- **Python:** 3.11+ (auto-installed if missing)
- **Node.js:** 18+ (auto-detected and guided)  
- **Memory:** 2GB+ RAM recommended
- **Storage:** 1GB+ available space
- **Network:** Internet for first-time setup only

---

## 🏆 **WHAT YOU GET**

### **🤖 AI Agent Mesh:**
- **Orchestrator:** Program leadership and coordination
- **ClauseWitch:** Legal IP protection and watermarking
- **Jarvess:** Intelligence synthesis and memory management
- **RoosterOps:** Daily standup and schedule enforcement
- **TriggerBot:** Event-driven automation and escalation
- **Sprint_Rider:** Execution and backlog management
- **Finish_Shit_Bot:** Task closure and loop termination
- **WhisperBot:** Communication relay and queue management
- **WhisperRelay:** Passive surveillance and message capture

### **🔧 Platform Features:**
- **Smart Narrative Card Protocol™:** Universal AI communication
- **Multi-AI Orchestration:** Claude + Gemini + GPT coordination  
- **Cryptographic Verification:** SHA256 + ProofLock integrity
- **Real-time Dashboard:** Live agent monitoring and control
- **Voice of Command:** GUI + API for agent coordination
- **Universal Command Surface:** Teams/Slack/Discord integration
- **Educational Sovereignty:** FERPA-compliant local processing
- **Patent Protection:** USPTO provisional filing coverage

---

## 💰 **VALUE PROPOSITION**

### **vs LinearB (Developer Metrics):**
| Feature | LinearB | KenPire Mesh OS |
|:--------|:--------|:----------------|
| **Focus** | Past metrics | Predictive AI automation |
| **Cost** | \$600/dev/year | \$200/dev one-time |
| **Deployment** | Cloud-only | Sovereign + USB capable |
| **AI Security** | None | Comprehensive risk dashboard |
| **ROI** | Subscription trap | 4-month break-even |

### **Educational Market:**
- **District License:** \$50K (Austin ISD pilot ready)
- **Per-School:** \$5K (individual campus deployment)
- **Teacher Training:** \$2K/session (implementation support)
- **Market Potential:** \$500K+ (Texas educational districts)

---

## 🔐 **SECURITY & COMPLIANCE**

### **Patent Protection:**
- **USPTO Status:** Provisional patent filed for multi-agent coordination
- **IP Defense:** ClauseWitch behavioral IP entity protection
- **Watermarking:** Automatic theft detection and prevention
- **Legal Framework:** Clause 4B educational sovereignty protection

### **Educational Compliance:**
- **FERPA Ready:** Student data protection verified
- **Local Processing:** No data leaves district infrastructure
- **Audit Trail:** Complete ProofLock verification chains
- **Accessibility:** WCAG 2.1 AA compliance for special needs

---

## 📞 **SUPPORT & CONTACT**

### **Creator:** Commander Ken Domaschk
- **GitHub:** @kendomaschk
- **Repository:** https://github.com/kendomaschk/kenpire-mesh-os
- **Business:** Patent-holding architect of sovereign AI systems

### **Technical Support:**
- **Documentation:** Full deployment guides included in package
- **Community:** GitHub Issues for technical questions
- **Enterprise:** Custom deployment and training available
- **Revenue Partner:** Educational district licensing opportunities

---

**🎯 Ready to deploy the world's first patent-protected sovereign AI operating system? Download and start your AI revolution today.**

*The future of AI coordination is here. Own it, don't rent it.*
EOF

echo "✅ Share instructions generated: $SHARE_FILE"
echo ""
echo "📋 QUICK SHARE OPTIONS:"
echo "======================"
echo ""
echo "1. 📧 Email this file to clients/partners"
echo "2. 📋 Copy contents to LinkedIn/social media" 
echo "3. 💾 Save to USB drive for physical handoff"
echo "4. 🌐 Upload to website/GitHub for public access"
echo ""
echo "📁 Generated file: $SHARE_FILE"
echo "📦 Package ready: $PACKAGE ($(du -sh "$PACKAGES_DIR/$PACKAGE" | cut -f1))"
echo ""
echo "🚀 Commander - Your patent-protected AI platform is ready for distribution!"