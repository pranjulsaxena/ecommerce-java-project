#!/bin/bash

# E-Commerce Developer 2 Services Startup Script
# This script starts RMI registry and PaymentServer for local development

set -e  # Exit on error

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLASSPATH="$PROJECT_ROOT/target/classes"
M2_REPO="$HOME/.m2/repository"

echo "========================================"
echo "Starting E-Commerce Developer 2 Services"
echo "========================================"
echo ""

# Add all JARs to classpath
if command -v find &> /dev/null; then
    for jar in $(find "$M2_REPO" -name "*.jar" -type f 2>/dev/null | head -20); do
        CLASSPATH="$CLASSPATH:$jar"
    done
else
    echo "Warning: 'find' command not available. Building manual classpath..."
    CLASSPATH="$CLASSPATH:$M2_REPO/org/postgresql/postgresql/42.7.2/postgresql-42.7.2.jar"
    CLASSPATH="$CLASSPATH:$M2_REPO/org/hibernate/hibernate-core/5.6.15.Final/hibernate-core-5.6.15.Final.jar"
fi

echo "[1/2] Starting RMI Registry on port 1099..."
rmiregistry 1099 &
RMI_PID=$!
sleep 2
echo "      ✓ RMI Registry started (PID: $RMI_PID)"
echo ""

echo "[2/2] Starting PaymentServer (RMI Service)..."
cd "$PROJECT_ROOT"
java -cp "$CLASSPATH" com.ecommerce.payment.PaymentServerImpl &
PAYMENT_PID=$!
sleep 3

# Check if PaymentServer is running
if ps -p $PAYMENT_PID > /dev/null; then
    echo "      ✓ PaymentServer started (PID: $PAYMENT_PID)"
else
    echo "      ✗ Failed to start PaymentServer"
    kill $RMI_PID 2>/dev/null
    exit 1
fi

echo ""
echo "========================================"
echo "✓ Services Started Successfully!"
echo "========================================"
echo ""
echo "RMI Registry:   localhost:1099"
echo "PaymentService: PaymentService (bound to RMI)"
echo ""
echo "Service PIDs:"
echo "  RMI Registry: $RMI_PID"
echo "  PaymentServer: $PAYMENT_PID"
echo ""
echo "To stop services, run:"
echo "  kill $RMI_PID $PAYMENT_PID"
echo ""
echo "Ready for testing with Tomcat server."
echo "========================================"

# Wait for services to run
wait
