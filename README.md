## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add radus https://lambdazen.github.io/metronome-helm-chart

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
radus` to see the charts.

To install the metronome chart:

    helm install my-metronome radus/metronome

To uninstall the chart:

    helm delete my-metronome
