1 pragma solidity ^0.4.11;
2 
3 contract Ambi2 {
4     function hasRole(address, bytes32, address) constant returns(bool);
5     function claimFor(address, address) returns(bool);
6     function isOwner(address, address) constant returns(bool);
7 }
8 
9 contract Ambi2Enabled {
10     Ambi2 ambi2;
11 
12     modifier onlyRole(bytes32 _role) {
13         if (address(ambi2) != 0x0 && ambi2.hasRole(this, _role, msg.sender)) {
14             _;
15         }
16     }
17 
18     // Perform only after claiming the node, or claim in the same tx.
19     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
20         if (address(ambi2) != 0x0) {
21             return false;
22         }
23 
24         ambi2 = _ambi2;
25         return true;
26     }
27 }
28 
29 contract Ambi2EnabledFull is Ambi2Enabled {
30     // Setup and claim atomically.
31     function setupAmbi2(Ambi2 _ambi2) returns(bool) {
32         if (address(ambi2) != 0x0) {
33             return false;
34         }
35         if (!_ambi2.claimFor(this, msg.sender) && !_ambi2.isOwner(this, msg.sender)) {
36             return false;
37         }
38 
39         ambi2 = _ambi2;
40         return true;
41     }
42 }
43 
44 contract EToken2Interface {
45     function reissueAsset(bytes32 _symbol, uint _value) returns(bool);
46     function changeOwnership(bytes32 _symbol, address _newOwner) returns(bool);
47 }
48 
49 contract AssetProxy {
50     EToken2Interface public etoken2;
51     bytes32 public etoken2Symbol;
52     function transferWithReference(address _to, uint _value, string _reference) returns (bool);
53 }
54 
55 contract BloquidIssuer is Ambi2EnabledFull {
56 
57     AssetProxy public assetProxy;
58 
59     function setupAssetProxy(AssetProxy _assetProxy) onlyRole("__root__") returns(bool) {
60         if ((address(assetProxy) != 0x0) || (address(_assetProxy) == 0x0)) {
61             return false;
62         }
63         assetProxy = _assetProxy;
64         return true;
65     }
66 
67     function issueTokens(uint _value, string _regNumber) onlyRole("issuer") returns(bool) {
68         bytes32 symbol = assetProxy.etoken2Symbol();
69         EToken2Interface etoken2 = assetProxy.etoken2();
70         if (!etoken2.reissueAsset(symbol, _value)) {
71             return false;
72         }
73         if (!assetProxy.transferWithReference(msg.sender, _value, _regNumber)) {
74             throw;
75         }
76         return true;
77     }
78 
79     function changeAssetOwner(address _newOwner) onlyRole("__root__") returns(bool) {
80         if (_newOwner == 0x0) {
81             return false;
82         }
83         bytes32 symbol = assetProxy.etoken2Symbol();
84         EToken2Interface etoken2 = assetProxy.etoken2();
85         if (!etoken2.changeOwnership(symbol, _newOwner)) {
86             return false;
87         }
88         return true;
89     }
90 
91 }