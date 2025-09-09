package resource

import (
	"fmt"

	"github.com/pandaritrl/valhalla-operator/internal/status"
	policyv1 "k8s.io/api/policy/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"
)

type PodDisruptionBudgetBuilder struct {
	*ValhallaResourceBuilder
}

func (builder *ValhallaResourceBuilder) PodDisruptionBudget() *PodDisruptionBudgetBuilder {
	return &PodDisruptionBudgetBuilder{builder}
}

func (builder *PodDisruptionBudgetBuilder) Build() (client.Object, error) {
	return &policyv1.PodDisruptionBudget{
		ObjectMeta: metav1.ObjectMeta{
			Name:      builder.Instance.ChildResourceName(HorizontalPodAutoscalerSuffix),
			Namespace: builder.Instance.Namespace,
		},
	}, nil
}

func (builder *PodDisruptionBudgetBuilder) Update(object client.Object) error {
	name := builder.Instance.ChildResourceName(PodDisruptionBudgetSuffix)
	pdb := object.(*policyv1.PodDisruptionBudget)

	pdb.Spec.MinAvailable = builder.Instance.Spec.GetMinAvailable()
	pdb.Spec.Selector = &metav1.LabelSelector{
		MatchLabels: map[string]string{
			"app": name,
		},
	}

	if err := controllerutil.SetControllerReference(builder.Instance, pdb, builder.Scheme); err != nil {
		return fmt.Errorf("failed setting controller reference: %v", err)
	}

	return nil
}

func (*PodDisruptionBudgetBuilder) ShouldDeploy(resources []runtime.Object) bool {
	return status.IsPersistentVolumeClaimBound(resources) && status.IsJobCompleted(resources)
}
