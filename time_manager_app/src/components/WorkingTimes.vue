<template>
  <div class="widget-working-times">
    <h1>{{ msg }}</h1>
    <div v-if="workingtimesData">
      <p>Start: {{ workingtimesData.start }}</p>
      <p>End: {{ workingtimesData.end }}</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'WorkingTimes',
  props: {
    msg: String,
    userId: {
      type: Number,
      default: null
    }
  },
  watch: {
    userId: function(newValue) {
      if(newValue) {
        this.fetchWorkingTimesData(newValue);
      }
    }
  },
  methods: {
    async fetchWorkingTimesData(userId) {
      try {
        const response = await axios.get(`http://52.47.210.151:4000/api/workingtimes/${userId}?start=2023-10-25T11:00:00Z&end=2023-10-27T15:00:00Z`);
        this.workingtimesData = response.data.data[0];
        console.log(this.workingtimesData)
      } catch (error) {
        console.error("There was an error fetching the user data:", error);
      }
    }
  },
  data() {
  return {
    workingtimesData: null
  };
},

}
</script>

<!-- Your scoped style remains the same -->
<style>
.widget-working-times{
  background-color: aquamarine;
  width: 20%;
}
</style>
