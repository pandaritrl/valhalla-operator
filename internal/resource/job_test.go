package resource_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/pandaritrl/valhalla-operator/internal/resource"
	"k8s.io/apimachinery/pkg/runtime"
)

var _ = Describe("Job builder", func() {
	Context("ShouldDeploy", func() {
		var builder resource.ResourceBuilder
		BeforeEach(func() {
			builder = valhallaResourceBuilder.Job()
		})

		It("Should always return 'true'", func() {
			resources := []runtime.Object{}
			Expect(builder.ShouldDeploy(resources)).To(Equal(true))
		})
	})
})
