# README
Main code and dataset for 'Population Coding of Eye Movements by Human Hand Knob for Eye-Hand Integration'.

1. System Requirements

    Operating System: MacOS

    MATLAB Version: R2022b

2. Code and database description

    All codes are organized into four separate directories corresponding to the four experimental groups in this project. Each experimental directory contains multiple .m files, as well as a Function folder and a Dataset folder. The individual .m files implement different computational procedures and are used to reproduce the main results and figures reported in the manuscript. The Function folder includes all essential functions required to run the project, while the Dataset folder contains the datasets used for demonstration purposes.

3. Code instructions

    We provide most of the code along with the corresponding usable datasets to reproduce the results of this study. Note that the datasets are provided for demonstration purposes only.

    3.1 Experiment 1
        3.1.1 PSD
            PSD averaged across the sites adjacent to and clearly situated outside the hand knob area. (Figure 1c)
        3.1.2 Time-frequency response
           Time-frequency responses of the hand knob area and other areas. (Figure 1d)
    
    3.2 Experiment 2
        3.2.1 Pie
            Calculate the percentage distribution of the single-units sensitive to eye, hand and both movements, as well as nonsensitive units.(Figure 2d)
        3.2.2 Neuronal_cluster
            Movement-related MUA in each electrode for the four directions of the two effectors. (Figure 2e)
        3.2.3 Corrlation
            Correlation matrix of population activity. Each square of a correlation matrix indicates the Pearson correlation coefficient of MUA from all electrodes between the two matched or unmatched directions of the same or different effectors. (figure 2f)
        3.2.4 SVM
            SVM classifier was used to quantify the information about tracking directions carried by the MUA from all electrodes. (Figure 2g)
        3.2.5 PCA
            Principal Component Analysis. (Figure 2h)

    3.3 Experiment 3
        3.3.1 Pie
            Calculate the percentage distributions of single-units tuned to somato-centered locations, extrinsic directions and intrinsic directions. (Figure 3c)
        3.3.2 SVM
            Calculate the accuracy of the classifiers in differentiating the two somato-centered locations, the two extrinsic directions, and the two intrinsic directions, Based on SVM classifier. (Figure 3d)
        3.3.3 PCA
            Principal Component Analysis. (Figure 3e)
        3.3.4 Corrlation
            Calculate the correlation between the eye- and hand-tracking for matched versus unmatched somato-centered location, extrinsic direction and intrinsic direction. 

    3.4 Experiment 4
        3.4.1 VennDiagrams
            Venn diagrams of the numbers of electrodes with different sensitivities. （Figure 4e）
        3.4.2 Hand_firingrate
            Calculate firing rate of hand movement.
        3.4.3 Eye_firingrate
            Calculate firing rate of eye movement.
        3.4.4 TwoD_sharedsubspace
            Pretest and posttest neural activities projected into the common subspaces. (Figure 5e/f/g)
        3.4.5 TwoD_ownsubspace
            Pretest and posttest neural activities projected into own subspaces. (Figure 6e/f/g)

4. Additional Information
    This content is licensed under MIT License.
