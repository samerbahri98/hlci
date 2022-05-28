default:
	vagrant up

.PHONY: acup
acup:
	vagrant up

.PHONY: acdown
acdown:
	vagrant destroy

.PHONY: acssh
acssh:
	vagrant ssh