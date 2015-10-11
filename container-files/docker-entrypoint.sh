if [ ! -z $OPENSHIFT_BUILD_NAMESPACE ] && [ -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
  # On OpenShift -> Discover Endpoints
  echo "----------------------------------- OpenShift - API -----------------------------------"
  echo "---------------------------------------------------------------------------------------"

  eps=$(/pod_endpoints.rb)

  elasticsearch -Des.node.master=$node_master \
      -Des.node.data=$node_data \
      -Des.http.enabled=$http_enabled \
      -Des.discovery.zen.ping.unicast.hosts=$eps
else
  # Not on OpenShift -> Run in Multicast Mode
  echo "----------------------------------- Multicast Mode -----------------------------------"
  echo "--------------------------------------------------------------------------------------"

  elasticsearch -Des.node.master=$node_master \
      -Des.node.data=$node_data \
      -Des.http.enabled=$http_enabled \
      -Des.discovery.zen.ping.multicast.enabled=true
fi
