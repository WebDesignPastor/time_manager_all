<script>

export default {
    name: 'EmployeeChart',
    components: {}
}

// il faut ajouter les deux graphiques correspondant aux employee => daily + weekly heures de travail
// puis ajouter deux boutons pour voir le dashboard ainsi que de créer des working time

</script>

<template>
    <div class="w-full h-56 px-6 py-4 bg-summarybg rounded-3xl shadow flex flex-col justify-between mt-8">
        <div class="flex justify-between items-center">
            <span class="text-second-text ml-2 text-xl font-bold">Employee working hours chart</span>
            <div>
                <select id="employee" class="bg-second-text text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5">
                <option selected>Employee</option>
                <option value="US">United States</option>
                <option value="CA">Canada</option>
                <option value="FR">France</option>
                <option value="DE">Germany</option>
                </select>
            </div>
        </div>
    </div>
</template>

<style>

</style>