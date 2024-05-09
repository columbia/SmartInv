1 pragma solidity ^0.4.11;
2 
3 //
4 // ==== DISCLAIMER ====
5 //
6 // ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
7 // ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
8 // IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
9 // YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
10 // DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
11 //
12 // THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
13 // AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
14 // INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
15 // OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
16 // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
17 // ====
18 //
19 //
20 // ==== PARANOIA NOTICE ====
21 // A careful reader will find some additional checks and excessive code, consuming some extra gas. This is intentional.
22 // Even though the contract should work without these parts, they make the code more secure in production and for future refactoring.
23 // Also, they show more clearly what we have considered and addressed during development.
24 // Discussion is welcome!
25 // ====
26 //
27 
28 /// @author written by ethernian for Santiment Sagl
29 /// @notice report bugs to: bugs@ethernian.com
30 /// @title Santiment WhiteList contract
31 contract SantimentWhiteList {
32 
33     string constant public VERSION = "0.3.1";
34 
35     function () { throw; }   //explicitly unpayable
36 
37     struct Limit {
38         uint24 min;  //finney
39         uint24 max;  //finney
40     }
41 
42     struct LimitWithAddr {
43         address addr;
44         uint24 min; //finney
45         uint24 max; //finney
46     }
47 
48     mapping(address=>Limit) public allowed;
49     uint16  public chunkNr = 0;
50     uint    public recordNum = 0;
51     uint256 public controlSum = 0;
52     bool public isSetupMode = true;
53     address public admin;
54 
55     function SantimentWhiteList() { admin = msg.sender; }
56 
57     ///@dev add next address package to the internal white list.
58     ///@dev call is allowed in setup mode only.
59     function addPack(address[] addrs, uint24[] mins, uint24[] maxs, uint16 _chunkNr)
60     setupOnly
61     adminOnly
62     external {
63         var len = addrs.length;
64         require ( chunkNr++ == _chunkNr);
65         require ( mins.length == len &&  mins.length == len );
66         for(uint16 i=0; i<len; ++i) {
67             var addr = addrs[i];
68             var max  = maxs[i];
69             var min  = mins[i];
70             Limit lim = allowed[addr];
71             //remove old record if exists
72             if (lim.max > 0) {
73                 controlSum -= uint160(addr) + lim.min + lim.max;
74                 delete allowed[addr];
75             }
76             //insert record if max > 0
77             if (max > 0) {
78                 // max > 0 means add a new record into the list.
79                 allowed[addr] = Limit({min:min, max:max});
80                 controlSum += uint160(addr) + min + max;
81             }
82         }//for
83         recordNum+=len;
84     }
85 
86     ///@notice switch off setup mode
87     function start()
88     adminOnly
89     public {
90         isSetupMode = false;
91     }
92 
93     modifier setupOnly {
94         if ( !isSetupMode ) throw;
95         _;
96     }
97 
98     modifier adminOnly {
99         if (msg.sender != admin) throw;
100         _;
101     }
102 
103 }