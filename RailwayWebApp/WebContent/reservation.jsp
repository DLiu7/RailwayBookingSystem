<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.example.login.Reservation" %>
<%
  if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("login2.jsp");
    return;
  }
  String user = (String) session.getAttribute("user");
  List<Reservation> curr = (List<Reservation>) request.getAttribute("currentReservations");
  List<Reservation> past = (List<Reservation>) request.getAttribute("pastReservations");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Make a Reservation</title>
  <link
    href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap"
    rel="stylesheet">
  <style>
    * { box-sizing:border-box; margin:0; padding:0 }
    html, body {
      height:100%; font-family:'Roboto',sans-serif;
      background:url('TP.jpg') no-repeat center center fixed;
      background-size:cover;
      display:flex; flex-direction:column; align-items:center;
    }
    .reservation-container {
      display:flex; gap:24px; align-items:flex-start;
      margin-top:40px;
    }
    .preview-box {
      background:rgba(10,37,64,0.85);
      color:#FFC947; padding:24px; border-radius:8px;
      width:180px; text-align:center;
      box-shadow:0 4px 12px rgba(0,0,0,0.3);
    }
    .preview-box h3 { margin-bottom:12px; font-size:1.25rem; }
    .preview-box .value { font-size:1.75rem; font-weight:700; }
    .card {
      background:#0A2540; border-radius:16px;
      box-shadow:0 8px 32px rgba(0,0,0,0.5);
      padding:40px; width:500px;
      animation:fadeIn .8s ease-out;
    }
    .card h2 { color:#fff; font-weight:500; margin-bottom:24px; }
    .input-group { margin-bottom:24px; text-align:left; }
    .input-group label, .input-group span {
      display:block; color:rgba(255,255,255,0.8);
      margin-bottom:6px; font-size:14px;
    }
    .input-group select,
    .input-group input[type="date"] {
      width:100%; padding:12px; border:none; border-radius:8px;
      background:rgba(255,255,255,0.15); color:#fff;
      font-size:16px; transition:background .3s;
    }
    .input-group select option { color:#000; background:#fff; }
    .input-group select:focus,
    .input-group input:focus { background:rgba(255,255,255,0.3); outline:none; }
    .trip-type {
      display:flex; gap:16px; margin-bottom:24px;
    }
    .trip-type input { transform:scale(1.1); margin-top:3px; }
    .trip-type label { color:#fff; font-size:14px; }
    .btn {
      display:block; width:100%; padding:12px; margin-top:24px;
      background:#FFD700; color:#0A2540; text-align:center;
      border:none; border-radius:24px; font-size:16px;
      font-weight:500; cursor:pointer;
      box-shadow:0 4px 16px rgba(0,0,0,0.3);
      transition:transform .2s,background .2s;
      text-decoration:none;
    }
    .btn:hover { background:#FFEA00; transform:translateY(-2px); }
    @keyframes fadeIn {
      from { opacity:0; transform:translateY(-20px) }
      to   { opacity:1; transform:translateY(0)    }
    }
    .reservations-list {
      width:90%; max-width:1000px; margin:40px auto; color:#fff;
    }
    .reservations-list h2 { margin-top:32px; }
    .reservation-table {
      width:100%; border-collapse:collapse; margin-bottom:32px;
    }
    .reservation-table th,
    .reservation-table td {
      padding:8px; border:1px solid rgba(255,255,255,0.3);
      text-align:center; font-size:14px;
    }
    .cancel-btn {
      background:#ff6961; color:#fff; border:none;
      padding:6px 12px; border-radius:4px; cursor:pointer;
    }
    .cancel-btn:hover { background:#ff4343; }
  </style>
</head>
<body>
  <div class="reservation-container">
    <!-- Fare -->
    <div class="preview-box">
      <h3>Estimated Fare</h3>
      <div class="value" id="fare-amount">$––.– –</div>
    </div>

    <!-- Form -->
    <div class="card">
      <h2>Hello, <%= user %> — Book a Train</h2>
      <form action="reserve" method="post">
        <div class="input-group">
          <span>Trip Type</span>
          <div class="trip-type">
            <input type="radio" id="oneway" name="tripType" value="One-way" checked>
            <label for="oneway">One-way</label>
            <input type="radio" id="roundtrip" name="tripType" value="Round-trip">
            <label for="roundtrip">Round-trip</label>
          </div>
        </div>
        <div class="input-group">
          <label for="train">Train</label>
          <select name="train" id="train" required>
            <option value="" disabled selected>Select train…</option>
            <option>NJ TRANSIT</option><option>AMTRAK</option>
          </select>
        </div>
        <div class="input-group">
          <label for="line">Line Code</label>
          <select name="lineName" id="line" required>
            <option value="" disabled selected>Select line…</option>
            <option>4000</option><option>4001</option>
            <option>4002</option><option>4003</option>
            <option>4005</option>
          </select>
        </div>
        <div class="input-group">
          <label for="date">Travel Date</label>
          <input type="date" name="departureDate" id="date" required/>
        </div>
        <div class="input-group">
          <label for="origin">Origin Station</label>
          <select name="originStationID" id="origin" required>
            <option value="" disabled selected>Select origin…</option>
            <option value="1">Newark Penn</option>
            <option value="2">New York Penn</option>
            <option value="3">New Brunswick</option>
            <option value="4">Trenton</option>
          </select>
        </div>
        <div class="input-group">
          <label for="destination">Destination Station</label>
          <select name="destinationStationID" id="destination" required>
            <option value="" disabled selected>Select destination…</option>
            <option value="1">Newark Penn</option>
            <option value="2">New York Penn</option>
            <option value="3">New Brunswick</option>
            <option value="4">Trenton</option>
          </select>
        </div>
        <div class="input-group">
          <label for="seat">Seat</label>
          <select name="seat" id="seat" required>
            <option value="" disabled selected>Select seat…</option>
            <option>A1</option><option>A2</option>
            <option>B1</option><option>B2</option>
            <option>C1</option><option>C2</option>
          </select>
        </div>
        <div class="input-group">
          <label for="passengerType">Passenger Type</label>
          <select name="passengerType" id="passengerType" required>
            <option value="" disabled selected>Select type…</option>
            <option>Adult</option>
            <option>Child</option>
            <option>Senior</option>
            <option>Disabled</option>
          </select>
        </div>
        <button type="submit" class="btn">Reserve Now</button>
      </form>
      <a href="welcome.jsp" class="btn">Back to Welcome</a>
    </div>

    <!-- Depart & Arrive -->
    <div class="preview-box">
      <h3>Departs At</h3>
      <div class="value" id="time-amount">––:––</div>
    </div>
    <div class="preview-box">
      <h3>Arrives At</h3>
      <div class="value" id="arrival-time-amount">––:––</div>
    </div>
  </div>

  <div class="reservations-list">
    <h2>Your Current Reservations</h2>
    <table class="reservation-table">
      <!-- … -->
    </table>
    <h2>Your Past Reservations</h2>
    <table class="reservation-table">
      <!-- … -->
    </table>
  </div>

  <script>
    // fare factors
    const stationFares   = {'1-2':15,'1-3':25,'1-4':27.5,'2-3':20,'2-4':30,'3-4':16.5};
    const passengerFacts = {Adult:1, Child:0.5, Senior:0.75, Disabled:0.7};

    // station lookup & base 4000 schedule
    const id2name = {
      '1':'Newark Penn','2':'New York Penn',
      '3':'New Brunswick','4':'Trenton'
    };
    const outbound = ['Trenton','New Brunswick','Newark Penn','New York Penn'];
    const inbound  = ['New York Penn','Newark Penn','New Brunswick','Trenton'];
    const baseOutboundSchedule = {
      'Trenton':'08:00','New Brunswick':'09:00',
      'Newark Penn':'10:00','New York Penn':'11:00'
    };
    const baseInboundSchedule = {
      'New York Penn':'14:00','Newark Penn':'15:00',
      'New Brunswick':'16:00','Trenton':'17:00'
    };

    // utility to add hours
    function shiftTime(timeStr, offset) {
      const [h,m] = timeStr.split(':').map(Number);
      const hh = h + offset;
      return String(hh).padStart(2,'0') + ':' + String(m).padStart(2,'0');
    }

    function updatePreview(){
      const o = document.getElementById('origin').value,
            d = document.getElementById('destination').value,
            l = document.getElementById('line').value,
            type = document.getElementById('passengerType').value,
            fact = passengerFacts[type]||1,
            trip = document.querySelector('input[name="tripType"]:checked').value,
            mult = trip==='Round-trip'?2:1;

      // fare preview
      let fare = '$––.– –';
      if(o && d && o!==d){
        const key = [o,d].sort().join('-'),
              base = stationFares[key]||0;
        fare = '$'+(base*fact*mult).toFixed(2);
      }
      document.getElementById('fare-amount').textContent = fare;

      // time preview
      let depart='––:––', arrive='––:––';

      if(l.startsWith('400')) {
        const offset = parseInt(l,10) - 4000;
        const oriName = id2name[o], dstName = id2name[d];
        const oi = outbound.indexOf(oriName), di = outbound.indexOf(dstName);
        if(oi>=0 && di>=0 && oi<di) {
          depart = shiftTime(baseOutboundSchedule[oriName], offset);
          arrive = shiftTime(baseOutboundSchedule[dstName], offset);
        } else {
          const ii = inbound.indexOf(oriName), idIndex = inbound.indexOf(dstName);
          if(ii>=0 && idIndex>=0 && ii<idIndex) {
            depart = shiftTime(baseInboundSchedule[oriName], offset);
            arrive = shiftTime(baseInboundSchedule[dstName], offset);
          }
        }
      }

      document.getElementById('time-amount').textContent         = depart;
      document.getElementById('arrival-time-amount').textContent = arrive;
    }

    ['origin','destination','line','passengerType']
      .forEach(id=>document.getElementById(id).addEventListener('change', updatePreview));
    document.getElementsByName('tripType')
      .forEach(r=> r.addEventListener('change', updatePreview));
  </script>
</body>
</html>
