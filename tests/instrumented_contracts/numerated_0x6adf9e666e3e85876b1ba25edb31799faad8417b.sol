1 pragma solidity ^0.4.6;
2 //
3 // Social Experiment - Finished (or is it... ;)
4 //
5 // This contract returns ether (plus bonus) to the "participant" who had contributed 100 ether to "my evil plan"
6 //
7 // Status FreeEtherADay:  SUCCESS
8 // Status HelpMeSave: FAILURE
9 // Status Free_Ether_A_Day_Funds_Return: TBD......
10 //
11 // But is this the end... we'll see. ;)
12 //
13 // Watch out for my blog report, will post link via PM to ppl involved
14 // and here https://www.reddit.com/r/ethtrader/comments/5foa5p/daily_discussion_30nov2016/dalsir4/
15 // And thanks to everyone who participated. Special mention goes out to /u/WhySoS3rious 
16 // and to 0xb7b8f253f9Df281EFE9E34F07F598f9817D6eb83
17 //
18 // Questions: drether00@gmail.com
19 //
20 
21 contract Free_Ether_A_Day_Funds_Return {
22    address owner;
23    address poorguy = 0xb7b8f253f9Df281EFE9E34F07F598f9817D6eb83;
24    
25    function Free_Ether_A_Day_Funds_Return() {
26         owner = msg.sender;
27    }
28   
29   // send 100 ether, I'll send back 210 ether ;)
30   // thats an additional 10 on top of your 100 for the inconvenience.
31   //   truuuuuuuust me....... no bugs this time ;---)
32   
33    function return_funds() payable {
34 
35        if (msg.sender != poorguy) throw;
36        
37        if (msg.value == 100 ether){
38              bool success = poorguy.send(210 ether);
39              if (!success) throw;
40        }
41        else throw;
42    }
43    
44    function() payable {}
45    
46    function kill(){
47        if (msg.sender == owner)
48            selfdestruct(owner);
49    }
50 }