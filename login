import React, { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { Form, Button, Row, Col } from 'react-bootstrap'
import { useDispatch, useSelector } from 'react-redux'
import Message from '../../components/Message'
import Loader from '../../components/Loader'
import Meta from '../../components/Meta'
import FormContainer from '../../components/FormContainer'
import { login } from '../../actions/userActions'
import '../Screens.css'

const LoginScreen = ({ location, history }) => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const dispatch = useDispatch()

  const userLogin = useSelector((state) => state.userLogin)
  const { loading, error, userInfo } = userLogin

  const redirect = location.search ? location.search.split('=')[1] : '/'
  const redirectAdmin = location.search
    ? location.search.split('=')[1]
    : '/admin/dashboard'
  const redirectEmployee = location.search
    ? location.search.split('=')[1]
    : '/employee/dashboard'

  useEffect(() => {
    if (userInfo && userInfo.isAdmin) {
      history.push(redirectAdmin)
    } else if (userInfo && userInfo.isClient) {
      history.push(redirect)
    } else if (userInfo && userInfo.isEmployee) {
      history.push(redirectEmployee)
    }
  }, [history, userInfo, redirect, redirectAdmin, redirectEmployee])

  const submitHandler = (e) => {
    e.preventDefault()
    dispatch(login(email, password))
  }

  return (
    <div className='loginScreen'>
      <Meta title='EAMS | Login' />
      <FormContainer>
        <h1>Sign In</h1>
        {error && <Message variant='danger'>{error}</Message>}
        {loading && <Loader />}
        <Form onSubmit={submitHandler}>
          <Form.Group controlId='email'>
            <Form.Label>Email Address</Form.Label>
            <Form.Control
              type='email'
              placeholder='Enter email'
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            ></Form.Control>
          </Form.Group>

          <Form.Group controlId='password'>
            <Form.Label>Password</Form.Label>
            <Form.Control
              type='password'
              placeholder='Enter password'
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            ></Form.Control>
          </Form.Group>

          <Button type='submit' variant='primary'>
            Sign In
          </Button>
        </Form>

        <Row className='py-3'>
          <Col>
            New Customer?{' '}
            <Link
              to={redirect ? `/register?redirect=${redirect}` : '/register'}
            >
              Register
            </Link>
          </Col>
        </Row>
        <Row>
          <Col>
            <Link to='/forgotpassword'>Forgotten password?</Link>
          </Col>
        </Row>
      </FormContainer>
    </div>
  )
}

export default LoginScreen
