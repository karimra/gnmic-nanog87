
# no   processor:  https://asciinema.org/a/557635
# with processor:  https://asciinema.org/a/557636
# deploy topology

cat topos/collector/gnmic.yaml  | yq e

sudo clab deploy -c -t topos/collector/nanog87.clab.yaml

echo "deployment done.."
sleep 30

echo "Query gNMIc Prometheus endpoint - curl -sSL clab-nanog87-gnmic:9804/metrics"
curl -sSL clab-nanog87-gnmic:9804/metrics
curl -sSL clab-nanog87-gnmic:9804/metrics | promtool check metrics

echo "Query Prometheus Server"
echo "promtool query instant 'http://clab-nanog87-prometheus:9090' 'interface_statistics_in_octets{source=\"clab-nanog87-leaf1\"}'"
promtool query instant 'http://clab-nanog87-prometheus:9090' 'interface_statistics_in_octets{source="clab-nanog87-leaf1"}'
echo "promtool query instant 'http://clab-nanog87-prometheus:9090' 'interface_statistics_in_octets{source=\"clab-nanog87-leaf2\"}'"
promtool query instant 'http://clab-nanog87-prometheus:9090' 'interface_statistics_in_octets{source="clab-nanog87-leaf2"}'
echo "promtool query instant 'http://clab-nanog87-prometheus:9090' 'interface_statistics_in_octets{source=\"clab-nanog87-spine1\"}'"
promtool query instant 'http://clab-nanog87-prometheus:9090' 'interface_statistics_in_octets{source="clab-nanog87-spine1"}'
