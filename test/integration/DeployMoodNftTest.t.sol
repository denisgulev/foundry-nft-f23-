// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    DeployMoodNft deployer;
    address user = makeAddr("user");
    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
    string public constant SAD_SVG_IMAGE_URI =
        "data:img/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNNTEyIDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYgNDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcyczE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIvPgogIDxwYXRoIGZpbGw9IiNFNkU2RTYiIGQ9Ik01MTIgMTQwYy0yMDUuNCAwLTM3MiAxNjYuNi0zNzIgMzcyczE2Ni42IDM3MiAzNzIgMzcyIDM3Mi0xNjYuNiAzNzItMzcyLTE2Ni42LTM3Mi0zNzItMzcyek0yODggNDIxYTQ4LjAxIDQ4LjAxIDAgMCAxIDk2IDAgNDguMDEgNDguMDEgMCAwIDEtOTYgMHptMzc2IDI3MmgtNDguMWMtNC4yIDAtNy44LTMuMi04LjEtNy40QzYwNCA2MzYuMSA1NjIuNSA1OTcgNTEyIDU5N3MtOTIuMSAzOS4xLTk1LjggODguNmMtLjMgNC4yLTMuOSA3LjQtOC4xIDcuNEgzNjBhOCA4IDAgMCAxLTgtOC40YzQuNC04NC4zIDc0LjUtMTUxLjYgMTYwLTE1MS42czE1NS42IDY3LjMgMTYwIDE1MS42YTggOCAwIDAgMS04IDguNHptMjQtMjI0YTQ4LjAxIDQ4LjAxIDAgMCAxIDAtOTYgNDguMDEgNDguMDEgMCAwIDEgMCA5NnoiLz4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNMjg4IDQyMWE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6bTIyNCAxMTJjLTg1LjUgMC0xNTUuNiA2Ny4zLTE2MCAxNTEuNmE4IDggMCAwIDAgOCA4LjRoNDguMWM0LjIgMCA3LjgtMy4yIDguMS03LjQgMy43LTQ5LjUgNDUuMy04OC42IDk1LjgtODguNnM5MiAzOS4xIDk1LjggODguNmMuMyA0LjIgMy45IDcuNCA4LjEgNy40SDY2NGE4IDggMCAwIDAgOC04LjRDNjY3LjYgNjAwLjMgNTk3LjUgNTMzIDUxMiA1MzN6bTEyOC0xMTJhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAweiIvPgo8L3N2Zz4=";
    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCIsICJkZXNjcmlwdGlvbiI6IkFuIE5GVCB0aGF0IHJlZmxlY3RzIHRoZSBtb29kIG9mIHRoZSBvd25lciwgMTAwJSBvbiBDaGFpbiEiLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAibW9vZGluZXNzIiwgInZhbHVlIjogMTAwfV0sICJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjNhV1IwYUQwaU1UQXlOSEI0SWlCb1pXbG5hSFE5SWpFd01qUndlQ0lnZG1sbGQwSnZlRDBpTUNBd0lERXdNalFnTVRBeU5DSWdlRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklqNEtJQ0E4Y0dGMGFDQm1hV3hzUFNJak16TXpJaUJrUFNKTk5URXlJRFkwUXpJMk5DNDJJRFkwSURZMElESTJOQzQySURZMElEVXhNbk15TURBdU5pQTBORGdnTkRRNElEUTBPQ0EwTkRndE1qQXdMallnTkRRNExUUTBPRk0zTlRrdU5DQTJOQ0ExTVRJZ05qUjZiVEFnT0RJd1l5MHlNRFV1TkNBd0xUTTNNaTB4TmpZdU5pMHpOekl0TXpjeWN6RTJOaTQyTFRNM01pQXpOekl0TXpjeUlETTNNaUF4TmpZdU5pQXpOeklnTXpjeUxURTJOaTQySURNM01pMHpOeklnTXpjeWVpSXZQZ29nSUR4d1lYUm9JR1pwYkd3OUlpTkZOa1UyUlRZaUlHUTlJazAxTVRJZ01UUXdZeTB5TURVdU5DQXdMVE0zTWlBeE5qWXVOaTB6TnpJZ016Y3ljekUyTmk0MklETTNNaUF6TnpJZ016Y3lJRE0zTWkweE5qWXVOaUF6TnpJdE16Y3lMVEUyTmk0MkxUTTNNaTB6TnpJdE16Y3llazB5T0RnZ05ESXhZVFE0TGpBeElEUTRMakF4SURBZ01DQXhJRGsySURBZ05EZ3VNREVnTkRndU1ERWdNQ0F3SURFdE9UWWdNSHB0TXpjMklESTNNbWd0TkRndU1XTXROQzR5SURBdE55NDRMVE11TWkwNExqRXROeTQwUXpZd05DQTJNell1TVNBMU5qSXVOU0ExT1RjZ05URXlJRFU1TjNNdE9USXVNU0F6T1M0eExUazFMamdnT0RndU5tTXRMak1nTkM0eUxUTXVPU0EzTGpRdE9DNHhJRGN1TkVnek5qQmhPQ0E0SURBZ01DQXhMVGd0T0M0MFl6UXVOQzA0TkM0eklEYzBMalV0TVRVeExqWWdNVFl3TFRFMU1TNDJjekUxTlM0MklEWTNMak1nTVRZd0lERTFNUzQyWVRnZ09DQXdJREFnTVMwNElEZ3VOSHB0TWpRdE1qSTBZVFE0TGpBeElEUTRMakF4SURBZ01DQXhJREF0T1RZZ05EZ3VNREVnTkRndU1ERWdNQ0F3SURFZ01DQTVObm9pTHo0S0lDQThjR0YwYUNCbWFXeHNQU0lqTXpNeklpQmtQU0pOTWpnNElEUXlNV0UwT0NBME9DQXdJREVnTUNBNU5pQXdJRFE0SURRNElEQWdNU0F3TFRrMklEQjZiVEl5TkNBeE1USmpMVGcxTGpVZ01DMHhOVFV1TmlBMk55NHpMVEUyTUNBeE5URXVObUU0SURnZ01DQXdJREFnT0NBNExqUm9ORGd1TVdNMExqSWdNQ0EzTGpndE15NHlJRGd1TVMwM0xqUWdNeTQzTFRRNUxqVWdORFV1TXkwNE9DNDJJRGsxTGpndE9EZ3VObk01TWlBek9TNHhJRGsxTGpnZ09EZ3VObU11TXlBMExqSWdNeTQ1SURjdU5DQTRMakVnTnk0MFNEWTJOR0U0SURnZ01DQXdJREFnT0MwNExqUkROalkzTGpZZ05qQXdMak1nTlRrM0xqVWdOVE16SURVeE1pQTFNek42YlRFeU9DMHhNVEpoTkRnZ05EZ2dNQ0F4SURBZ09UWWdNQ0EwT0NBME9DQXdJREVnTUMwNU5pQXdlaUl2UGdvOEwzTjJaejQ9In0=";

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testConvertSvgToURI() public view {
        string memory actualURI = deployer.svgToImageURI(
            '<svg viewBox="0 0 200 200" width="400"  height="400" xmlns="http://www.w3.org/2000/svg"><circle cx="100" cy="100" fill="yellow" r="78" stroke="black" stroke-width="3"/><g class="eyes"><circle cx="61" cy="82" r="12"/><circle cx="127" cy="82" r="12"/></g><path d="m136.81 116.53c.69 26.17-64.11 42-81.52-.73" style="fill:none; stroke: black; stroke-width: 3;"/></svg>'
        );

        assert(
            keccak256(abi.encodePacked(HAPPY_SVG_IMAGE_URI)) !=
                keccak256(abi.encodePacked(actualURI))
        );
    }

    function testFirstTokenURIExists() public {
        vm.prank(user);
        moodNft.mintNft();
        assert(
            keccak256(abi.encodePacked(HAPPY_SVG_IMAGE_URI)) !=
                keccak256(abi.encodePacked(moodNft.tokenURI(0)))
        );
    }

    function testFlipMood() public {
        vm.prank(user);
        moodNft.mintNft(); // Mood = HAPPY
        console.log("Mood pre-flip: ", uint256(moodNft.getMood(0)));
        vm.prank(user);
        moodNft.flipMood(0); // Mood = SAD
        console.log("Mood post-flip: ", uint256(moodNft.getMood(0)));
        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(SAD_SVG_URI))
        );
    }
}
