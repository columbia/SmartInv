1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-02
3 */
4 
5 pragma experimental ABIEncoderV2;
6 pragma solidity ^0.6.0;
7 
8 
9 interface IACL {
10     function accessible(address sender, address to, bytes4 sig)
11         external
12         view
13         returns (bool);
14 }
15 
16 contract Oracle {
17     address public ACL;
18 
19     constructor (address _ACL) public {
20         ACL = _ACL;
21     }
22 
23     modifier auth {
24         require(IACL(ACL).accessible(msg.sender, address(this), msg.sig), "access unauthorized");
25         _;
26     }
27 
28     function setACL(
29         address _ACL) external {
30         require(msg.sender == ACL, "require ACL");
31         ACL = _ACL;
32     }
33 
34     struct Price {
35         uint price;
36         uint  expiration;
37     }
38 
39     mapping (address => Price) public prices;
40 
41     function getExpiration(address token) external view returns (uint) {
42         return prices[token].expiration;
43     }
44 
45     function getPrice(address token) external view returns (uint) {
46         return prices[token].price;
47     }
48 
49     function get(address token) external view returns (uint, bool) {
50         return (prices[token].price, valid(token));
51     }
52 
53     function valid(address token) public view returns (bool) {
54         return now < prices[token].expiration;
55     }
56 
57     // 设置价格为 @val, 保持有效时间为 @exp second.
58     function set(address token, uint val, uint exp) external auth {
59         prices[token].price = val;
60         prices[token].expiration = now + exp;
61     }
62 
63     //批量设置，减少gas使用
64     function batchSet(address[] calldata tokens, uint[] calldata vals, uint[] calldata exps) external auth {
65         uint nToken = tokens.length;
66         require(nToken == vals.length && vals.length == exps.length, "invalid array length");
67         for (uint i = 0; i < nToken; ++i) {
68             prices[tokens[i]].price = vals[i];
69             prices[tokens[i]].expiration = now + exps[i];
70         }
71     }
72 }