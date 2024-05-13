1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {NFTRecoveryAccountant} from "../accountants/NFTAccountant.sol";
5 
6 contract MockNftAccountant is NFTRecoveryAccountant {
7     mapping(address => bool) public allowList;
8 
9     constructor() NFTRecoveryAccountant(address(0), address(1)) {}
10 
11     function exposed_increaseTotalAffected(address _asset) public {
12         if (totalAffected[_asset] == 0) {
13             totalAffected[_asset] = 5000 ether;
14         } else {
15             totalAffected[_asset] = totalAffected[_asset] + 10 ether;
16         }
17     }
18 
19     function exposed_record(
20         address _asset,
21         address _user,
22         uint256 _amount
23     ) external {
24         _record(_asset, _user, _amount);
25     }
26 
27     modifier onlyAllowed() {
28         require(allowList[msg.sender], "not allowed");
29         _;
30     }
31 
32     function recover(uint256 _id) external onlyAllowed {
33         address _user = ownerOf(_id);
34         require(_user == msg.sender, "only NFT holder can recover");
35         Record memory _rec = records[_id];
36         uint256 _amount = 0.5 ether;
37         _rec.recovered += uint96(_amount);
38         emit Recovery(_id, _rec.asset, _user, _amount);
39     }
40 
41     function allow(address who) external {
42         allowList[who] = true;
43     }
44 
45     function disallow(address who) external {
46         allowList[who] = false;
47     }
48 
49     function allow(address[] calldata _who) external {
50         for (uint256 i = 0; i < _who.length; i++) {
51             allowList[_who[i]] = true;
52         }
53     }
54 
55     function disallow(address[] calldata _who) external {
56         for (uint256 i = 0; i < _who.length; i++) {
57             allowList[_who[i]] = false;
58         }
59     }
60 
61     function info(uint256 _id)
62         external
63         view
64         returns (
65             address _holder,
66             bool _isAllowed,
67             string memory _uri,
68             address _asset,
69             uint256 _originalAmount,
70             address _originalUser,
71             uint256 _recovered,
72             uint256 _recoverable
73         )
74     {
75         _holder = ownerOf(_id);
76         _isAllowed = allowList[_holder];
77         _uri = tokenURI(_id);
78         Record memory _rec = records[_id];
79         _asset = _rec.asset;
80         _originalAmount = uint256(_rec.amount);
81         _originalUser = _rec.originalUser;
82         _recovered = uint256(_rec.recovered);
83         _recoverable = 0.05 ether;
84     }
85 }
