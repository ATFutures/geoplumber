/**
 * geoplumber R package code.
 */
import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import IconButton from '@material-ui/core/IconButton';
import { Link } from '@material-ui/core';
// import MenuIcon from '@material-ui/icons/Menu';

// import { withRouter } from 'react-router';

const navs = ["test", "about"];

const useStyles = makeStyles((theme) => {
  console.log(theme)
  return({
  root: {
    flexGrow: 1,
    backgroundColor: "#000"
  },
  menuButton: {
    marginRight: theme.spacing(2),
  },
  title: {
    flexGrow: 1,
  },
  maxHeight: 40
})});

const Header = function () {
  const classes = useStyles();

  return (
    <div>
      <AppBar 
        className={classes.root}
        position="sticky">
        <Toolbar variant="dense">
          <IconButton edge="start"
            className={classes.menuButton}
            color="inherit" aria-label="menu">
            {/* <MenuIcon /> */}
          </IconButton>
          <Typography variant="h6"
            className={classes.title}>
            <Link href="/">geoplumber</Link>
          </Typography>
          {
            navs.map(e => <Button
              href={"/" + e}
              color="inherit">{e}</Button>)
          }
        </Toolbar>
      </AppBar>
    </div>
  );
}

// thanks https://stackoverflow.com/a/42124328/2332101
export default Header;
