1 pragma solidity 0.4.18;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) onlyOwner public {
29     require(newOwner != address(0));
30     OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33 }
34 /*
35   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
36   Licensed under the Apache License, Version 2.0 (the "License");
37   you may not use this file except in compliance with the License.
38   You may obtain a copy of the License at
39   http://www.apache.org/licenses/LICENSE-2.0
40   Unless required by applicable law or agreed to in writing, software
41   distributed under the License is distributed on an "AS IS" BASIS,
42   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
43   See the License for the specific language governing permissions and
44   limitations under the License.
45 */
46 /// @title LRC Foundation Airdrop Address Binding Contract
47 /// @author Kongliang Zhong - <kongliang@loopring.org>,
48 contract LRxAirdropAddressBinding is Ownable {
49     mapping(address => mapping(uint8 => string)) public bindings;
50     mapping(uint8 => string) public projectNameMap;
51     event AddressesBound(address sender, uint8 projectId, string targetAddr);
52     event AddressesUnbound(address sender, uint8 projectId);
53     // @projectId: 1=LRN, 2=LRQ
54     function bind(uint8 projectId, string targetAddr)
55         external
56     {
57         require(projectId > 0);
58         bindings[msg.sender][projectId] = targetAddr;
59         AddressesBound(msg.sender, projectId, targetAddr);
60     }
61     function unbind(uint8 projectId)
62         external
63     {
64         require(projectId > 0);
65         delete bindings[msg.sender][projectId];
66         AddressesUnbound(msg.sender, projectId);
67     }
68     function getBindingAddress(address owner, uint8 projectId)
69         external
70         view
71         returns (string)
72     {
73         require(projectId > 0);
74         return bindings[owner][projectId];
75     }
76     function setProjectName(uint8 id, string name) onlyOwner external {
77         projectNameMap[id] = name;
78     }
79 }