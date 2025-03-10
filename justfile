set quiet := true

default:
    just --list --unsorted

generate image: decrypt && encrypt
    -nix build path:.#{{ image }}

decrypt:
    sops decrypt --extract '["tailscale-auth-key"]' --output tailscale-auth-key.dec secrets.yaml

encrypt:
    rm tailscale-auth-key.dec

update:
    nix flake update --commit-lock-file

fmt:
    nix fmt
