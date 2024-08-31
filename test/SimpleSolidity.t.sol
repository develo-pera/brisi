// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {SimpleSolidity} from "../src/SimpleSolidity.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleSolidityTest is Test {
    SimpleSolidity simpleSolidity;

    function setUp() public {
        simpleSolidity = new SimpleSolidity();
    }

    function testInitialState() public {
        string memory message = simpleSolidity.message();
        assertEq(message, string(""));

        uint256 likesCount = simpleSolidity.likesCount();
        uint256 dislikesCount = simpleSolidity.dislikesCount();
        assertEq(likesCount, 0);
        assertEq(dislikesCount, 0);

        address owner = simpleSolidity.owner();
        assertEq(owner, address(this));
    }

    function testSettingMessage() public {
        simpleSolidity.like();
        simpleSolidity.dislike();
        assertEq(simpleSolidity.likesCount(), 1);
        assertEq(simpleSolidity.dislikesCount(), 1);

        string memory oldMessage = simpleSolidity.message();
        vm.expectEmit();
        emit SimpleSolidity.MessageChanged(oldMessage, "my new message");
        simpleSolidity.setMessage("my new message");

        assertEq(simpleSolidity.likesCount(), 0);
        assertEq(simpleSolidity.dislikesCount(), 0);
        assertNotEq(oldMessage, simpleSolidity.message());
        assertEq(simpleSolidity.message(), "my new message");
    }

    function testSettingMessageRevert() public {
        vm.prank(vm.addr(0x1));
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, vm.addr(0x1)));
        simpleSolidity.setMessage("Don't fail me");
    }

    function testLiking() public {
        uint256 likesCountBefore = simpleSolidity.likesCount();
        simpleSolidity.like();
        uint256 likesCountAfter = simpleSolidity.likesCount();
        assertEq(likesCountAfter, likesCountBefore + 1);

        vm.expectEmit();
        emit SimpleSolidity.Like(address(this), simpleSolidity.message());
        simpleSolidity.like();
    }

    function testDisliking() public {
        uint256 dislikesCountBefore = simpleSolidity.dislikesCount();
        simpleSolidity.dislike();
        uint256 dislikesCountAfter = simpleSolidity.dislikesCount();
        assertEq(dislikesCountAfter, dislikesCountBefore + 1);

        vm.expectEmit();
        emit SimpleSolidity.Dislike(address(this), simpleSolidity.message());
        simpleSolidity.dislike();
    }

    function testPlainETHTransfer() public {
        uint256 contractBalanceBefore = address(simpleSolidity).balance;
        assertEq(contractBalanceBefore, 0);

        address donor = vm.addr(0x1);
        deal(donor, 1 ether);
        vm.prank(donor);

        address(simpleSolidity).call{value: 1 ether}("");

        uint256 contractBalanceAfterTransfer = address(simpleSolidity).balance;
        assertEq(contractBalanceAfterTransfer, 1e18);
    }
}
