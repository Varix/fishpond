% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loadFry.R
\name{loadFry}
\alias{loadFry}
\alias{load_fry_raw}
\title{Load in data from alevin-fry USA mode}
\usage{
load_fry_raw(fryDir, verbose = FALSE)

loadFry(fryDir, outputFormat = "scRNA", nonzero = FALSE, verbose = FALSE)
}
\arguments{
\item{fryDir}{A path to the output directory returned by
alevin-fry quant command. This directory should contain a
\code{metainfo.json}, and an alevin folder which contains
\code{quants_mat.mtx}, \code{quants_mat_cols.txt} and
\code{quants_mat_rows.txt}}

\item{verbose}{A boolean specifying if showing
messages when running the function}

\item{outputFormat}{This argument can \emph{either} be a list that defines the desired format of the output 
\code{SingleCellExperiment} object \emph{or} a string that represents one of 
the pre-defined output formats, which are "scRNA", "snRNA", "scVelo" and "velocity". 
See details for the explainations of the pre-defined formats and how to define custom format.}

\item{nonzero}{A boolean specifying if filtering
genes with non-zero expression value across all cells in the output \code{SingleCellExperiment} object.}
}
\value{
A \code{SingleCellExperiment} object that contains one or more assay slots.
Each assay slot consists of a gene by cell
count matrix. The row names are feature names, and the column
names are cell barcodes.
}
\description{
Enables easy loading of sparse data matrices provided by alevin-fry USA mode.
Alevin-fry - \url{https://www.biorxiv.org/content/10.1101/2021.06.29.450377v1}
}
\section{Details about \code{loadFry}}{

This function consumes the result folder returned by running
alevin-fry quant in unspliced, spliced, ambiguous (USA) 
quantification mode, and returns a \code{SingleCellExperiement} object
that contains a final count for each gene within each cell. In
USA mode, alevin-fry quant returns a count matrix contains three
types of count for each feature (gene) within each sample (cell
or nucleus), which represent the spliced mRNA count of the gene (U),
the unspliced mRNA count of the gene (S), and the count of mRNA whose
splicing status is ambiguous (A). For each slot defined by \code{outputFormat},
these three counts of a gene within a cell will be summed 
to get the final count of the gene according to the rule defined in the \code{outputFormat}. 
The returned object will contains the desired slots defined by \code{outputFormat}, 
with rownames as the barcode of samples and colnames as the feature names.
}

\section{Details about the output format}{

The \code{outputFormat} argument takes \emph{either} be a list that defines 
the desired format of the output 
\code{SingleCellExperiment} object \emph{or} a string that represents one of 
the pre-defined output format. 

Currently the pre-defined formats 
of the output \code{SingleCellExperiment} object are: 
\describe{
\item{"scRNA":}{This format is recommended for single cell experiments. 
It returns a \code{counts} assay slot that contains the S+A count of each gene in each cell.}
\item{"snRNA":}{This format is recommended for single nucleus experiments. 
It returns a \code{counts} assay slot that contains the U+S+A count of each gene in each cell.}
\item{"raw":}{This format put the three kinds of counts into three separate assay slots, 
which are \code{unspliced}, \code{spliced} and \code{ambiguous}.}
\item{"velocity":}{This format contains two assay slots. 
The \code{spliced} slot contains the S+A count of each gene in each cell.
The \code{unspliced} slot contains the U counts of each gene in each cell.}
\item{"scVelo":}{This format is for direct entry into velociraptor R package or 
other scVelo downstream analysis pipeline for velocity
analysis in R with Bioconductor. It adds the expected 
"S"-pliced assay and removes errors for size factors being
non-positive.}
}

A custom output format can be defined using a list. Each element in the list 
defines an assay slot in the output \code{SingleCellExperiment} object. 
The name of an element in the list will be the name of the corresponding 
assay slot in the output object. Each element in the list should be defined as 
a vector that takes at least one of the three kinds of count, which are U, S and A.
See the provided toy example for defining a custom output format.
}

\section{Details about \code{load_fry_raw}}{

This function processes alevin-fry's quantification result contained within the input folder.
This function returns a list that consists of the gene count matrix, the gene names list, the barcode list, 
and some metadata, such as the number of genes in the experiment and whether alevin-fry was executed 
in USA mode. In the returned list, the all-in-one count matrix, \code{count_mat}, 
returned from the USA mode of alevin-fry consists of the spliced count of genes defined in \code{gene.names}
for all barcodes defined in \code{barcodes}, followed by the unspliced count of genes in the same order 
for all cells, then followed by the ambiguous count of genes in the same order for all cells.
}

\examples{

# Get path for minimal example avelin-fry output dir
testdat <- fishpond:::readExampleFryData("fry-usa-basic")

# This is exactly how the velocity format defined internally.
custom_velocity_format = list("spliced" = c("S", "A"), "unspliced" = c("U"))

# Load alevin-fry gene quantification in velocity format
sce <- loadFry(fryDir = testdat$parent_dir, outputFormat = custom_velocity_format, verbose = TRUE)
SummarizedExperiment::assayNames(sce)

# Load the same data but use pre-defined, velociraptor R pckage desired format
scvelo_format = "scVelo"

scev <- loadFry(fryDir = testdat$parent_dir, outputFormat = scvelo_format, nonzero = TRUE)
SummarizedExperiment::assayNames(scev)

}
\concept{preprocessing}
