1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4 
5   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
6 }
7 
8 contract Ownable {
9 
10   address owner;
11   address pendingOwner;
12 
13   modifier onlyOwner {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   modifier onlyPendingOwner {
19     require(msg.sender == pendingOwner);
20     _;
21   }
22 
23   function Ownable() {
24     owner = msg.sender;
25   }
26 
27   function transferOwnership(address newOwner) onlyOwner {
28     pendingOwner = newOwner;
29   }
30 
31   function claimOwnership() onlyPendingOwner {
32     owner = pendingOwner;
33   }
34 }
35 
36 contract Destructible is Ownable {
37 
38   function destroy() onlyOwner {
39     selfdestruct(msg.sender);
40   }
41 }
42 
43 contract WithClaim {
44     
45     event Claim(string data);
46 }
47 
48 // Mainnet: 0xFd74f0ce337fC692B8c124c094c1386A14ec7901
49 // Rinkeby: 0xC5De286677AC4f371dc791022218b1c13B72DbBd
50 // Ropsten: 0x6f32a6F579CFEed1FFfDc562231C957ECC894001
51 // Kovan:   0x139d658eD55b78e783DbE9bD4eb8F2b977b24153
52 
53 contract UserfeedsClaimWithoutValueTransfer is Destructible, WithClaim {
54 
55   function post(string data) {
56     Claim(data);
57   }
58 }
59 
60 // Mainnet: 0x70B610F7072E742d4278eC55C02426Dbaaee388C
61 // Rinkeby: 0x00034B8397d9400117b4298548EAa59267953F8c
62 // Ropsten: 0x37C1CA7996CDdAaa31e13AA3eEE0C89Ee4f665B5
63 // Kovan:   0xc666c75C2bBA9AD8Df402138cE32265ac0EC7aaC
64 
65 contract UserfeedsClaimWithValueTransfer is Destructible, WithClaim {
66 
67   function post(address userfeed, string data) payable {
68     userfeed.transfer(msg.value);
69     Claim(data);
70   }
71 }
72 
73 // Mainnet: 0xfF8A1BA752fE5df494B02D77525EC6Fa76cecb93
74 // Rinkeby: 0xBd2A0FF74dE98cFDDe4653c610E0E473137534fB
75 // Ropsten: 0x54b4372fA0bd76664B48625f0e8c899Ff19DFc39
76 // Kovan:   0xd6Ede7F43882B100C6311a9dF801088eA91cEb64
77 
78 contract UserfeedsClaimWithTokenTransfer is Destructible, WithClaim {
79 
80   function post(address userfeed, address token, uint value, string data) {
81     var erc20 = ERC20(token);
82     require(erc20.transferFrom(msg.sender, userfeed, value));
83     Claim(data);
84   }
85 }