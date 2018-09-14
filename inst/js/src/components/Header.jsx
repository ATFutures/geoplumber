/**
 * geoplumber R package code.
 */
import React from 'react';
import { Navbar, Nav, NavItem } from 'react-bootstrap';
import { Link, withRouter } from 'react-router-dom';

const navs = [
    {
        key: 1,
        to: "test",
        title: "Test"
    },
    {
        key: 2,
        to: "about",
        title: "About"
    },
];

class Header extends React.Component {

    render () {
        return (
            <Navbar inverse collapseOnSelect>
                <Navbar.Header>
                    <Navbar.Brand>
                        <Link to="/">geoplumber</Link>
                    </Navbar.Brand>
                    <Navbar.Toggle />
                </Navbar.Header>
                <Navbar.Collapse>
                    <Nav>
                        {
                            navs.map((item, i) => {
                                return(
                                    <NavItem
                                    key={i}
                                    eventKey={item.key}
                                    onClick={() => this.props.history.push(item.to)}>
                                        {item.title}
                                    </NavItem>
                                )
                            })
                        }
                    </Nav>
                </Navbar.Collapse>
            </Navbar>
        )
    }
}

// thanks to https://stackoverflow.com/a/42124328/2332101
export default withRouter(Header);
