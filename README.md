# tf-loki-stack
Terraform Loki-Stack (Loki and Promtail).

How to use it:

```
module "loki_stack" {
  source          = "git::https://github.com/taulanthalili/tf-loki-stack.git?ref=main"
  namespace       = var.project_name
  environment     = var.environment
  argocd_project  = "default"
  depends_on      = [module.argocd]
}
```
