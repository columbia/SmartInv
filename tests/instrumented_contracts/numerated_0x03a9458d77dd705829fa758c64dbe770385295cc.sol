1 pragma solidity ^0.4.24;
2 
3 /**
4  *  @title PolicyRegistry
5  *  @author Enrique Piqueras - <epiquerass@gmail.com>
6  *  @dev A contract to maintain a policy for each subcourt.
7  */
8 contract PolicyRegistry {
9     /* Events */
10 
11     /** @dev Emitted when a policy is updated.
12      *  @param _subcourtID The ID of the policy's subcourt.
13      *  @param _policy The URI of the policy JSON.
14      */
15     event PolicyUpdate(uint indexed _subcourtID, string _policy);
16 
17     /* Storage */
18 
19     address public governor;
20     mapping(uint => string) public policies;
21 
22     /* Modifiers */
23 
24     /** @dev Requires that the sender is the governor. */
25     modifier onlyByGovernor() {require(governor == msg.sender, "Can only be called by the governor."); _;}
26 
27     /* Constructor */
28 
29     /** @dev Constructs the `PolicyRegistry` contract.
30      *  @param _governor The governor's address.
31      */
32     constructor(address _governor) public {governor = _governor;}
33 
34     /* External */
35 
36     /** @dev Changes the `governor` storage variable.
37      *  @param _governor The new value for the `governor` storage variable.
38      */
39     function changeGovernor(address _governor) external onlyByGovernor {governor = _governor;}
40 
41     /** @dev Sets the policy for the specified subcourt.
42      *  @param _subcourtID The ID of the specified subcourt.
43      *  @param _policy The URI of the policy JSON.
44      */
45     function setPolicy(uint _subcourtID, string _policy) external onlyByGovernor {
46         emit PolicyUpdate(_subcourtID, policies[_subcourtID]);
47         policies[_subcourtID] = _policy;
48     }
49 }