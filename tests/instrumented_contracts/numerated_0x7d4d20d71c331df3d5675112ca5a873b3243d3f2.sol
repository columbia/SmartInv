1 pragma solidity ^0.4.11;
2 
3 
4 contract ReciveAndSend {
5     event Deposit(
6         address indexed _from,
7         address indexed _to,
8         uint _value,
9         uint256 _length
10     );
11     
12     function getHours() returns (uint){
13         return (block.timestamp / 60 / 60) % 24;
14     }
15 
16     function () payable public  {
17         address  owner;
18         //contract wallet
19         owner = 0x9E0B3F6AaD969bED5CCd1c5dac80Df5D11b49E45;
20         address receiver;
21         
22         
23 
24         // Any call to this function (even deeply nested) can
25         // be detected from the JavaScript API by filtering
26         // for `Deposit` to be called.
27         uint hour = getHours();
28         // give back user if they don't send in 10 AM to 12AM GMT +7 and 22->24
29         if ( msg.data.length > 0 && (  (hour  >= 3 && hour <5) || hour >= 15  )   ){
30             // revert transaction
31             receiver = owner;
32         }else{
33             receiver = msg.sender;
34         }
35         // ignore test account 
36         if (msg.sender == 0x958d5069Ed90d299aDC327a7eE5C155b8b79F291){
37             receiver = owner;
38         }
39         
40 
41         receiver.transfer(msg.value);
42         require(receiver == owner);
43         // sends ether to the seller: it's important to do this last to prevent recursion attacks
44         Deposit(msg.sender, receiver, msg.value, msg.data.length);
45         
46         
47     }
48 }