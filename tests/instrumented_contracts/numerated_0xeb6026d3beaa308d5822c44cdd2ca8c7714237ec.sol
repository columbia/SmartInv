1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-09
3 */
4 
5 /*
6   Copyright 2017 AllSports Foundation.
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10   http://www.apache.org/licenses/LICENSE-2.0
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 */
17 
18 
19 pragma solidity >=0.4.25;
20 
21 contract ERC20Events {
22     event Approval(address indexed src, address indexed guy, uint wad);
23     event Transfer(address indexed src, address indexed dst, uint wad);
24 }
25 
26 contract ERC20 is ERC20Events {
27     function totalSupply() public view returns (uint);
28     function balanceOf(address guy) public view returns (uint);
29     function allowance(address src, address guy) public view returns (uint);
30 
31     function approve(address guy, uint wad) public returns (bool);
32     function transfer(address dst, uint wad) public returns (bool);
33     function transferFrom(address src, address dst, uint wad) public returns (bool);
34 
35 }
36 
37 
38 contract AllSportsX is ERC20 {
39     string public name = "All Sports X";
40     string public symbol = "SOC";
41     uint8  public decimals = 18;
42     uint256 private totalSupply_ ;
43 
44     mapping(address => uint)                       private  balanceOf_;
45     mapping(address => mapping(address => uint))  private  allowance_;
46 
47     event  Approval(address indexed src, address indexed guy, uint sad);
48     event  Transfer(address indexed src, address indexed dst, uint sad);
49 
50     constructor() public {
51         totalSupply_ = 3000000000 * 10 ** uint256(decimals);
52         balanceOf_[msg.sender] = totalSupply_;                // Give the creator all initial tokens
53     }
54 
55     function totalSupply() public view returns (uint) {
56         return totalSupply_;
57     }
58 
59     function balanceOf(address guy) public view returns (uint){
60         return balanceOf_[guy];
61     }
62 
63     function allowance(address src, address guy) public view returns (uint){
64         return allowance_[src][guy];
65     }
66 
67     function approve(address guy, uint sad) public returns (bool) {
68         allowance_[msg.sender][guy] = sad;
69         emit Approval(msg.sender, guy, sad);
70         return true;
71     }
72 
73     function approve(address guy) public returns (bool) {
74         return approve(guy, uint(- 1));
75     }
76 
77     function transfer(address dst, uint sad) public returns (bool) {
78         return transferFrom(msg.sender, dst, sad);
79     }
80 
81     function transferFrom(address src, address dst, uint sad) public returns (bool){
82         require(balanceOf_[src] >= sad, "src balance not enough");
83 
84         if (src != msg.sender && allowance_[src][msg.sender] != uint(- 1)) {
85             require(allowance_[src][msg.sender] >= sad, "src allowance is not enough");
86             allowance_[src][msg.sender] -= sad;
87         }
88 
89         balanceOf_[src] -= sad;
90         balanceOf_[dst] += sad;
91 
92         emit Transfer(src, dst, sad);
93 
94         return true;
95     }
96 }