`cat /etc/kubernetes/admin.conf`{{execute HOST1}}

`scp root@<master ip>:/etc/kubernetes/admin.conf .`{{execute HOST2}}
`kubectl --kubeconfig ./admin.conf get nodes`{{execute HOST2}}
