1 // compiler: 0.4.20+commit.3155dd80.Emscripten.clang
2 pragma solidity ^0.4.20;
3 
4 contract owned {
5   address public owner;
6 
7   function owned() public {
8     owner = msg.sender;
9   }
10 
11   function changeOwner( address newowner ) public onlyOwner {
12     owner = newowner;
13   }
14 
15   modifier onlyOwner {
16     if (msg.sender != owner) { revert(); }
17     _;
18   }
19 }
20 
21 contract Community is owned {
22 
23   event Receipt( address indexed sender, uint value );
24 
25   string  public name_; // "IT", "KO", ...
26   address public manager_;
27   uint    public bonus_;
28   uint    public start_;
29   uint    public end_;
30 
31   function Community() public {}
32 
33   function setName( string _name ) public onlyOwner {
34     name_ = _name;
35   }
36 
37   function setManager( address _mgr ) public onlyOwner {
38     manager_ = _mgr;
39   }
40 
41   function setBonus( uint _bonus ) public onlyOwner {
42     bonus_ = _bonus;
43   }
44 
45   function setTimes( uint _start, uint _end ) public onlyOwner {
46     require( _end > _start );
47 
48     start_ = _start;
49     end_ = _end;
50   }
51 
52   // set gas limit to something greater than 24073
53   function() public payable {
54     require( now >= start_ && now <= end_ );
55 
56     owner.transfer( msg.value );
57 
58     Receipt( msg.sender, msg.value );
59   }
60 }