use crate::{air::frame::Frame, fri::fri_decommit::FriDecommitment};
use lambdaworks_crypto::merkle_tree::proof::Proof;
use lambdaworks_math::field::{element::FieldElement, traits::IsFFTField};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone)]
pub struct DeepPolynomialOpenings<F: IsFFTField> {
    pub lde_composition_poly_even_proof: Proof<F>,
    pub lde_composition_poly_even_evaluation: FieldElement<F>,
    pub lde_composition_poly_odd_proof: Proof<F>,
    pub lde_composition_poly_odd_evaluation: FieldElement<F>,
    pub lde_trace_merkle_proofs: Vec<Proof<F>>,
    pub lde_trace_evaluations: Vec<FieldElement<F>>,
}

#[derive(Debug, Clone)]
pub struct StarkProof<F: IsFFTField> {
    // Commitments of the trace columns
    // [tⱼ]
    pub lde_trace_merkle_roots: Vec<FieldElement<F>>,
    // tⱼ(zgᵏ)
    pub trace_ood_frame_evaluations: Frame<F>,
    // [H₁]
    pub composition_poly_even_root: FieldElement<F>,
    // H₁(z²)
    pub composition_poly_even_ood_evaluation: FieldElement<F>,
    // [H₂]
    pub composition_poly_odd_root: FieldElement<F>,
    // H₂(z²)
    pub composition_poly_odd_ood_evaluation: FieldElement<F>,
    // [pₖ]
    pub fri_layers_merkle_roots: Vec<FieldElement<F>>,
    // pₙ
    pub fri_last_value: FieldElement<F>,
    // Open(p₀(D₀), 𝜐ₛ), Opwn(pₖ(Dₖ), −𝜐ₛ^(2ᵏ))
    pub query_list: Vec<FriDecommitment<F>>,
    // Open(H₁(D_LDE, 𝜐₀), Open(H₂(D_LDE, 𝜐₀), Open(tⱼ(D_LDE), 𝜐₀)
    pub deep_poly_openings: DeepPolynomialOpenings<F>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StarkProofString {
    pub lde_trace_merkle_roots: Vec<String>,
    pub trace_ood_frame_evaluations: Vec<String>,
    pub trace_ood_frame_evaluations_row_width: usize,
    pub composition_poly_even_root: String,
    pub composition_poly_even_ood_evaluation: String,
    pub composition_poly_odd_root: String,
    pub composition_poly_odd_ood_evaluation: String,
    pub fri_layers_merkle_roots: Vec<String>,
    pub fri_last_value: String,
    pub query_list: Vec<FriDecommitmentString>,
    pub deep_poly_openings: DeepPolynomialOpeningsString,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FriDecommitmentString {
    pub layers_auth_paths_sym: Vec<ProofString>,
    pub layers_evaluations_sym: Vec<String>,
    pub first_layer_evaluation: String,
    pub first_layer_auth_path: ProofString,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DeepPolynomialOpeningsString {
    pub lde_composition_poly_even_proof: ProofString,
    pub lde_composition_poly_even_evaluation: String,
    pub lde_composition_poly_odd_proof: ProofString,
    pub lde_composition_poly_odd_evaluation: String,
    pub lde_trace_merkle_proofs: Vec<ProofString>,
    pub lde_trace_evaluations: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProofString {
    pub merkle_path: Vec<String>,
}

pub fn convert_stark_proof_to_string<F: IsFFTField>(proof: StarkProof<F>) -> StarkProofString {
    let lde_trace_merkle_roots: Vec<String> = proof
        .lde_trace_merkle_roots
        .iter()
        .map(|fe| fe.representative().to_string())
        .collect();
    let trace_ood_frame_evaluations: Vec<String> = proof
        .trace_ood_frame_evaluations
        .data
        .iter()
        .map(|fe| fe.representative().to_string())
        .collect();
    let trace_ood_frame_evaluations_row_width: usize = proof.trace_ood_frame_evaluations.row_width;
    let composition_poly_even_root: String = proof
        .composition_poly_even_root
        .representative()
        .to_string();
    let composition_poly_even_ood_evaluation: String = proof
        .composition_poly_even_ood_evaluation
        .representative()
        .to_string();
    let composition_poly_odd_root: String =
        proof.composition_poly_odd_root.representative().to_string();

    let composition_poly_odd_ood_evaluation = proof
        .composition_poly_odd_ood_evaluation
        .representative()
        .to_string();

    let fri_layers_merkle_roots = proof
        .fri_layers_merkle_roots
        .iter()
        .map(|fe| fe.representative().to_string())
        .collect();

    let fri_last_value = proof.fri_last_value.representative().to_string();

    let query_list: Vec<FriDecommitmentString> = proof
        .query_list
        .iter()
        .map(|decommitment| FriDecommitmentString {
            layers_auth_paths_sym: decommitment
                .layers_auth_paths_sym
                .iter()
                .map(|proof| ProofString {
                    merkle_path: proof
                        .merkle_path
                        .iter()
                        .map(|fe| fe.representative().to_string())
                        .collect(),
                })
                .collect(),
            layers_evaluations_sym: decommitment
                .layers_evaluations_sym
                .iter()
                .map(|fe| fe.representative().to_string())
                .collect(),
            first_layer_evaluation: decommitment
                .first_layer_evaluation
                .representative()
                .to_string(),
            first_layer_auth_path: ProofString {
                merkle_path: decommitment
                    .first_layer_auth_path
                    .merkle_path
                    .iter()
                    .map(|fe| fe.representative().to_string())
                    .collect(),
            },
        })
        .collect();

    let deep_poly_openings = DeepPolynomialOpeningsString {
        lde_composition_poly_even_proof: ProofString {
            merkle_path: proof
                .deep_poly_openings
                .lde_composition_poly_even_proof
                .merkle_path
                .iter()
                .map(|fe| fe.representative().to_string())
                .collect(),
        },
        lde_composition_poly_even_evaluation: proof
            .deep_poly_openings
            .lde_composition_poly_even_evaluation
            .representative()
            .to_string(),
        lde_composition_poly_odd_proof: ProofString {
            merkle_path: proof
                .deep_poly_openings
                .lde_composition_poly_odd_proof
                .merkle_path
                .iter()
                .map(|fe| fe.representative().to_string())
                .collect(),
        },
        lde_composition_poly_odd_evaluation: proof
            .deep_poly_openings
            .lde_composition_poly_odd_evaluation
            .representative()
            .to_string(),
        lde_trace_merkle_proofs: proof
            .deep_poly_openings
            .lde_trace_merkle_proofs
            .iter()
            .map(|proof| ProofString {
                merkle_path: proof
                    .merkle_path
                    .iter()
                    .map(|fe| fe.representative().to_string())
                    .collect(),
            })
            .collect(),
        lde_trace_evaluations: proof
            .deep_poly_openings
            .lde_trace_evaluations
            .iter()
            .map(|fe| fe.representative().to_string())
            .collect(),
    };
    return StarkProofString {
        lde_trace_merkle_roots: lde_trace_merkle_roots,
        trace_ood_frame_evaluations: trace_ood_frame_evaluations,
        trace_ood_frame_evaluations_row_width: trace_ood_frame_evaluations_row_width,
        composition_poly_even_root: composition_poly_even_root,
        composition_poly_even_ood_evaluation: composition_poly_even_ood_evaluation,
        composition_poly_odd_root: composition_poly_odd_root,
        composition_poly_odd_ood_evaluation: composition_poly_odd_ood_evaluation,
        fri_layers_merkle_roots: fri_layers_merkle_roots,
        fri_last_value: fri_last_value,
        query_list: query_list,
        deep_poly_openings: deep_poly_openings,
    };
}
