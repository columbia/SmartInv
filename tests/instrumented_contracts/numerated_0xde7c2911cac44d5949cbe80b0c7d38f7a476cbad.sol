1 pragma solidity ^0.4.25;
2  
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10   constructor() public {
11     owner = 0x2C43dfBAc5FC1808Cb8ccEbCc9E24BEaB1aaa816;//msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) public onlyOwner {
20     require(newOwner != address(0));
21     emit OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 
25 }
26 
27 
28 
29 contract SimpleWallet is Ownable {
30 
31     address public wallet1 = 0xf038F656b511Bf37389b8Ae22D44fB3395327007;
32     address public wallet2 = 0xf038F656b511Bf37389b8Ae22D44fB3395327007;
33     
34     address public newWallet1 = 0xf038F656b511Bf37389b8Ae22D44fB3395327007;
35     address public newWallet2 = 0xf038F656b511Bf37389b8Ae22D44fB3395327007;
36     
37     function setNewWallet1(address _newWallet1) public onlyOwner {
38         newWallet1 = _newWallet1;
39     }    
40     
41     function setNewWallet2(address _newWallet2) public onlyOwner {
42         newWallet2 = _newWallet2;
43     }  
44     
45     function setWallet1(address _wallet1) public {
46         require(msg.sender == wallet1);
47         require(newWallet1 == _wallet1);
48         
49         wallet1 = _wallet1;
50     }    
51     
52     function setWallet2(address _wallet2) public {
53         require(msg.sender == wallet2);
54         require(newWallet2 == _wallet2);
55         
56         wallet2 = _wallet2;
57     }  
58     
59     
60     function withdraw() public{
61         require( (msg.sender == wallet1)||(msg.sender == wallet2) );
62         uint half = address(this).balance/2;
63         wallet1.send(half);
64         wallet2.send(half);
65     } 
66     
67       function () public payable {
68         
69       }     
70     
71 }