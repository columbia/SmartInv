1 pragma solidity 0.5.9;
2 
3 /**
4  * @title BatchAttestationLogic
5  * @notice AttestationLogic allows users to submit the root hash of a batch
6  *  attestation Merkle tree
7  */
8 contract BatchAttestationLogic {
9   event BatchTraitAttested(
10     bytes32 rootHash
11     );
12 
13   /**
14    * @notice Function for anyone to submit the root hash of a batch attestation merkle tree
15    * @param _dataHash Root hash of batch merkle tree
16    */
17   function batchAttest(
18     bytes32 _dataHash
19   ) external {
20     emit BatchTraitAttested(_dataHash);
21   }
22 }