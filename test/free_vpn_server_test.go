package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFreeVPNServer(t *testing.T) {
	t.Parallel()

	expectedName := fmt.Sprintf("free-vpn-test-%s", random.UniqueId())

	awsRegion := "eu-central-1"

	terraformOptions := &terraform.Options{
		TerraformDir: "../server",

		Vars: map[string]interface{}{
			"server_name": expectedName,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	instanceID := terraform.Output(t, terraformOptions, "instance_id")
	vpnUrl := terraform.Output(t, terraformOptions, "access_vpn_url")

	aws.AddTagsToResource(t, awsRegion, instanceID, 
		map[string]string{"testing": "testing-free-vpn"})

	instanceTags := aws.GetTagsForEc2Instance(t, awsRegion, instanceID)

	testingTag, containsTestingTag := instanceTags["testing"]
	assert.True(t, containsTestingTag)
	assert.Equal(t, "testing-free-vpn", testingTag)

	nameTag, containsNameTag := instanceTags["Name"]
	assert.True(t, containsNameTag)
	assert.Equal(t, expectedName, nameTag)

	assert.Regexp(t, ":943/admin", vpnUrl)
}