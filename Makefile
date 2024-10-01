.PHONY: all help setup_multipass generate_inventory setup_master setup_nodes post_install destroy

GREEN := \033[0;32m
NC := \033[0m # No Color

all: setup_multipass generate_inventory setup_master setup_nodes post_install

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  ${GREEN}help${NC}               : Show this help message"
	@echo "  ${GREEN}setup_multipass${NC}    : Set up multipass instances"
	@echo "  ${GREEN}generate_inventory${NC} : Generate Ansible inventory file"
	@echo "  ${GREEN}setup_master${NC}       : Set up the k3s master node"
	@echo "  ${GREEN}setup_nodes${NC}        : Set up the k3s worker nodes"
	@echo "  ${GREEN}post_install${NC}       : Run post-installation tasks"
	@echo "  ${GREEN}destroy${NC}            : Destroy the entire cluster"
	@echo "  ${GREEN}all${NC}                : Run all steps"

setup_multipass:
	@echo "${GREEN}Setting up multipass instances...${NC}"
	./multipass-up.sh

generate_inventory: setup_multipass
	@echo "${GREEN}Generating Ansible inventory file...${NC}"
	./obtain-ips.sh

setup_master: generate_inventory
	@echo "${GREEN}Setting up k3s master node...${NC}"
	ansible-playbook playbooks/k3s_master.yml

setup_nodes: setup_master
	@echo "${GREEN}Setting up k3s worker nodes...${NC}"
	ansible-playbook playbooks/k3s_nodes.yml

post_install: setup_nodes
	@echo "${GREEN}Running post-installation tasks...${NC}"
	ansible-playbook playbooks/post.yml

destroy:
	@echo "${GREEN}Destroying the entire cluster...${NC}"
	./destroy.sh
