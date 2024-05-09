1 pragma solidity ^0.4.11;
2 
3 contract KillSwitch {
4     address private Boss;
5     bool private Dont;
6     
7     modifier Is_Boss() {
8         if (msg.sender != Boss) {
9             Dont = true;
10         }
11         _;
12     }
13  
14  
15    function KillSwitch()
16    {
17      Boss = msg.sender;    
18    }
19    
20    function KillSwitchEngaged(address _Location) 
21     public payable
22     Is_Boss()
23     returns (bool success)
24    {
25        if(Dont == true) 
26        {
27            Dont = false;
28            return false;
29        }
30        else
31        {
32            selfdestruct(_Location);
33            return true;
34        }
35    }
36    function() public payable {
37       
38    } 
39 }