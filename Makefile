.PHONY: all help setup_multipass setup_master setup_nodes post_install destroy

GREEN := \033[0;32m
NC := \033[0m # No Color

all: setup_multipass setup_master setup_nodes post_install

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  ${GREEN}help${NC}         : Show this help message"
	@echo "  ${GREEN}setup_master${NC} : Set up the k3s master node"
	@echo "  ${GREEN}setup_nodes${NC}  : Set up the k3s worker nodes"
	@echo "  ${GREEN}destroy${NC}      : Destroy the entire cluster"
	@echo "  ${GREEN}all${NC}          : Run all steps (setup_multipass, setup_master, setup_nodes, post_install)"

setup_multipass:
	@echo "${GREEN}Setting up multipass instances...${NC}"
	./multipass-up.sh

setup_master: setup_multipass
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
