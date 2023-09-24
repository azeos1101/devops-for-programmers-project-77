terraform {
  cloud {
    organization = "hexlet_project_3_xorgo"

    workspaces {
      name = "dev"
    }
  }
}
