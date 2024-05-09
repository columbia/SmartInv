1 pragma solidity 0.5.11;
2 pragma experimental ABIEncoderV2;
3 
4 interface KeyRingFactoryV2 {
5   function newKeyRing(address userSigningKey, address targetKeyRing) external returns (address keyRing);
6 }
7 
8 
9 interface SmartWallet {
10   struct Call {
11     address to;
12     bytes data;
13   }
14   
15   function executeAction(
16     address to,
17     bytes calldata data,
18     uint256 minimumActionGas,
19     bytes calldata userSignature,
20     bytes calldata dharmaSignature
21   ) external returns (bool ok, bytes memory returnData);
22   
23   function executeActionWithAtomicBatchCalls(
24     Call[] calldata calls,
25     uint256 minimumActionGas,
26     bytes calldata userSignature,
27     bytes calldata dharmaSignature
28   ) external returns (bool[] memory ok, bytes[] memory returnData);
29 }
30 
31 
32 contract KeyRingGenericDeployerHelper {
33   KeyRingFactoryV2 internal constant _FACTORY = KeyRingFactoryV2(
34     0x2484000059004afB720000dc738434fA6200F49D
35   );
36     
37   function newKeyRingAndGenericAction(
38     address userSigningKey,
39     address targetKeyRing,
40     address smartWallet,
41     address to,
42     bytes calldata data,
43     uint256 minimumActionGas,
44     bytes calldata userSignature,
45     bytes calldata dharmaSignature
46   ) external returns (
47     address keyRing, bool genericActionOK, bytes memory genericActionReturnData
48   ) {
49     keyRing = _FACTORY.newKeyRing(userSigningKey, targetKeyRing);
50     (genericActionOK, genericActionReturnData) = SmartWallet(smartWallet).executeAction(
51       to, data, minimumActionGas, userSignature, dharmaSignature
52     );
53   }
54   
55   function newKeyRingAndExecuteActionWithAtomicBatchCalls(
56     address userSigningKey,
57     address targetKeyRing,
58     address smartWallet,
59     SmartWallet.Call[] calldata calls,
60     uint256 minimumActionGas,
61     bytes calldata userSignature,
62     bytes calldata dharmaSignature
63   ) external returns (
64     address keyRing, bool[] memory ok, bytes[] memory returnData
65   ) {
66     keyRing = _FACTORY.newKeyRing(userSigningKey, targetKeyRing);
67     (ok, returnData) = SmartWallet(smartWallet).executeActionWithAtomicBatchCalls(
68       calls, minimumActionGas, userSignature, dharmaSignature
69     );
70   }
71 }