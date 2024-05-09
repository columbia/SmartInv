1 /* A contract to exchange encrypted messages. Most of the work done on
2    the client side. */
3 
4 contract comm_channel {
5 	
6     address owner;
7     
8     event content(string datainfo, string senderKey, string recipientKey, uint amount);
9     modifier onlyowner { if (msg.sender == owner) _ }
10     
11     function comm_channel() public { owner = msg.sender; }
12     
13     ///TODO: remove in release
14     function kill() onlyowner { suicide(owner); }
15 
16     function flush() onlyowner {
17         owner.send(this.balance);
18     }
19 
20     function add(string datainfo, string senderKey, string recipientKey,
21                  address resendTo) {
22         
23         //try to resend money from message to the address
24         if(msg.value > 0) {
25             if(resendTo == 0) throw;
26             if(!resendTo.send(msg.value)) throw;
27         }
28         
29         //write to blockchain
30         content(datainfo, senderKey, recipientKey, msg.value);
31     }
32 }